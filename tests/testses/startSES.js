// Copyright (C) 2011 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * @fileoverview Make this frame SES-safe or die trying.
 *
 * <p>Assumes ES5 plus a WeakMap that conforms to the anticipated ES6
 * WeakMap spec. Compatible with ES5-strict or anticipated ES6.
 *
 * @author Mark S. Miller,
 * @requires WeakMap
 * @overrides ses, console, eval, Function, cajaVM
 */
var ses;


/**
 * The global {@code eval} function available to script code, which
 * may or not be made safe.
 *
 * <p>The original global binding of {@code eval} is not
 * SES-safe. {@code cajaVM.eval} is a safe wrapper around this
 * original eval, enforcing SES language restrictions.
 *
 * <p>If {@code TAME_GLOBAL_EVAL} is true, both the global {@code
 * eval} variable and {@code sharedImports.eval} are set to the safe
 * wrapper. If {@code TAME_GLOBAL_EVAL} is false, in order to work
 * around a bug in the Chrome debugger, then the global {@code eval}
 * is unaltered and no {@code "eval"} property is available on {@code
 * sharedImports}. In either case, SES-evaled-code and SES-script-code
 * can both access the safe eval wrapper as {@code cajaVM.eval}.
 *
 * <p>By making the safe eval available on {@code sharedImports} only
 * when we also make it be the genuine global eval, we preserve the
 * property that SES-evaled-code differs from SES-script-code only by
 * having a subset of the same variables in globalish scope. This is a
 * nice-to-have that makes explanation easier rather than a hard
 * requirement. With this property, any SES-evaled-code that does not
 * fail to access a global variable (or to test whether it could)
 * should operate the same way when run as SES-script-code.
 *
 * <p>See doc-comment on cajaVM for the restriction on this API needed
 * to operate under Caja translation on old browsers.
 */
var eval;

/**
 * The global {@code Function} constructor is always replaced with a
 * safe wrapper, which is also made available as
 * {@code sharedImports.Function}.
 *
 * <p>Both the original Function constructor and this safe wrapper
 * point at the original {@code Function.prototype}, so {@code
 * instanceof} works fine with the wrapper. {@code
 * Function.prototype.constructor} is set to point at the safe
 * wrapper, so that only it, and not the unsafe original, is
 * accessible.
 *
 * <p>See doc-comment on cajaVM for the restriction on this API needed
 * to operate under Caja translation on old browsers.
 */
var Function;

/**
 * A new global exported by SES, intended to become a mostly
 * compatible API between server-side Caja translation for older
 * browsers and client-side SES verification for newer browsers.
 *
 * <p>Under server-side Caja translation for old pre-ES5 browsers, the
 * synchronous interface of the evaluation APIs (currently {@code
 * eval, Function, cajaVM.{compileExpr, compileModule, eval, Function}})
 * cannot reasonably be provided. Instead, under translation we expect
 * <ul>
 * <li>Not to have a binding for {@code "eval"} on
 *     {@code sharedImports}, just as we would not if
 *     {@code TAME_GLOBAL_EVAL} is false.
 * <li>The global {@code eval} seen by scripts is either unaltered (to
 *     work around the Chrome debugger bug if {@code TAME_GLOBAL_EVAL}
 *     is false), or is replaced by a function that throws an
 *     appropriate EvalError diagnostic (if {@code TAME_GLOBAL_EVAL}
 *     is true).
 * <li>The global {@code Function} constructor, both as seen by script
 *     code and evaled code, to throw an appropriate diagnostic.
 * <li>The {@code Q} API to always be available, to handle
 *     asynchronous, promise, and remote requests.
 * <li>The evaluating methods on {@code cajaVM} -- currently {@code
 *     compileExpr, compileModule, eval, and Function} -- to be remote
 *     promises for their normal interfaces, which therefore must be
 *     invoked with {@code Q.post}.
 * <li>Since {@code Q.post} can be used for asynchronously invoking
 *     non-promises, invocations like
 *     {@code Q.post(cajaVM, 'eval', ['2+3'])}, for example,
 *     will return a promise for a 5. This should work both under Caja
 *     translation and (TODO(erights)) under SES verification when
 *     {@code Q} is also installed, and so is the only portable
 *     evaluating API that SES code should use during this transition
 *     period.
 * <li>TODO(erights): {@code Q.post(cajaVM, 'compileModule',
 *     [moduleSrc]} should eventually pre-load the transitive
 *     synchronous dependencies of moduleSrc before resolving the
 *     promise for its result. It currently would not, instead
 *     requiring its client to do so manually.
 * </ul>
 */
var cajaVM;

/**
 * <p>{@code ses.startSES} should be called before any other potentially
 * dangerous script is executed in this frame.
 *
 * <p>If {@code ses.startSES} succeeds, the evaluation operations on
 * {@code cajaVM}, the global {@code Function} contructor, and perhaps
 * the {@code eval} function (see doc-comment on {@code eval} and
 * {@code cajaVM}) will only load code according to the <i>loader
 * isolation</i> rules of the object-capability model, suitable for
 * loading untrusted code. If all other (trusted) code executed
 * directly in this frame (i.e., other than through these safe
 * evaluation operations) takes care to uphold object-capability
 * rules, then untrusted code loaded via these safe evaluation
 * operations will be constrained by those rules. TODO(erights):
 * explain concretely what the trusted code must do or avoid doing to
 * uphold object-capability rules.
 *
 * <p>On a pre-ES5 platform, this script will fail cleanly, leaving
 * the frame intact. Otherwise, if this script fails, it may leave
 * this frame in an unusable state. All following description assumes
 * this script succeeds and that the browser conforms to the ES5
 * spec. The ES5 spec allows browsers to implement more than is
 * specified as long as certain invariants are maintained. We further
 * assume that these extensions are not maliciously designed to obey
 * the letter of these invariants while subverting the intent of the
 * spec. In other words, even on an ES5 conformant browser, we do not
 * presume to defend ourselves from a browser that is out to get us.
 *
 * @param global ::Record(any) Assumed to be the real global object
 *        for some frame. Since {@code ses.startSES} will allow global
 *        variable references that appear at the top level of the
 *        whitelist, our safety depends on these variables being
 *        frozen as a side effect of freezing the corresponding
 *        properties of {@code global}. These properties are also
 *        duplicated onto the virtual global objects which are
 *        provided as the {@code this} binding for the safe
 *        evaluation calls -- emulating the safe subset of the normal
 *        global object.
 *        TODO(erights): Currently, the code has only been tested when
 *        {@code global} is the global object of <i>this</i>
 *        frame. The code should be made to work for cross-frame use.
 * @param whitelist ::Record(Permit) where Permit = true | "*" |
 *        "skip" | Record(Permit).  Describes the subset of naming
 *        paths starting from {@code sharedImports} that should be
 *        accessible. The <i>accessible primordials</i> are all values
 *        found by navigating these paths starting from {@code
 *        sharedImports}. All non-whitelisted properties of accessible
 *        primordials are deleted, and then {@code sharedImports}
 *        and all accessible primordials are frozen with the
 *        whitelisted properties frozen as data properties.
 *        TODO(erights): fix the code and documentation to also
 *        support confined-ES5, suitable for confining potentially
 *        offensive code but not supporting defensive code, where we
 *        skip this last freezing step. With confined-ES5, each frame
 *        is considered a separate protection domain rather that each
 *        individual object.
 * @param atLeastFreeVarNames ::F([string], Record(true))
 *        Given the sourceText for a strict Program,
 *        atLeastFreeVarNames(sourceText) returns a Record whose
 *        enumerable own property names must include the names of all the
 *        free variables occuring in sourceText. It can include as
 *        many other strings as is convenient so long as it includes
 *        these. The value of each of these properties should be
 *        {@code true}. TODO(erights): On platforms with Proxies
 *        (currently only Firefox 4 and after), use {@code
 *        with(aProxy) {...}} to intercept free variables rather than
 *        atLeastFreeVarNames.
 * @param extensions ::F([], Record(any)]) A function returning a
 *        record whose own properties will be copied onto cajaVM. This
 *        is used for the optional components which bring SES to
 *        feature parity with the ES5/3 runtime at the price of larger
 *        code size. At the time that {@code startSES} calls {@code
 *        extensions}, {@code cajaVM} exists but should not yet be
 *        used. In particular, {@code extensions} should not call
 *        {@code cajaVM.def} during this setup, because def would then
 *        freeze priordials before startSES cleans them (removes
 *        non-whitelisted properties). The methods that
 *        {@code extensions} contributes can, of course, use
 *        {@code cajaVM}, since those methods will only be called once
 *        {@code startSES} finishes.
 */
ses.startSES = function(global, whitelist, atLeastFreeVarNames, extensions) {
  "use strict";


  /////////////// KLUDGE SWITCHES ///////////////

  /////////////////////////////////
  // The following are only the minimal kludges needed for the current
  // Firefox or the current Chrome Beta. At the time of
  // this writing, these are Firefox 4.0 and Chrome 12.0.742.5 dev
  // As these move forward, kludges can be removed until we simply
  // rely on ES5.

  /**
   * <p>TODO(erights): isolate and report this.
   *
   * <p>Workaround for Chrome debugger's own use of 'eval'
   *
   * <p>This kludge is safety preserving but not semantics
   * preserving. When {@code TAME_GLOBAL_EVAL} is false, no {@code
   * sharedImports.eval} is available, and the 'eval' available as a
   * global to trusted (script) code is the original 'eval', and so is
   * not safe.
   */
  //var TAME_GLOBAL_EVAL = true;
  var TAME_GLOBAL_EVAL = false;


  //////////////// END KLUDGE SWITCHES ///////////


  var dirty = true;

  var hop = Object.prototype.hasOwnProperty;

  function fail(str) {
    debugger;
    throw new EvalError(str);
  }

  if (typeof WeakMap === 'undefined') {
    fail('No built-in WeakMaps, so WeakMap.js must be loaded first');
  }

  /**
   * Code being eval'ed by {@code cajaVM.eval} sees {@code
   * sharedImports} as its top-level {@code this}, as if {@code
   * sharedImports} were the global object.
   *
   * <p>{@code sharedImports}'s properties are exactly the whitelisted
   * global variable references. These properties, both as they appear
   * on the global object and on this {@code sharedImports} object,
   * are frozen and so cannot diverge. This preserves the illusion.
   *
   * <p>For code being evaluated by {@code cajaVM.compileExpr} and its
   * ilk, the {@code imports} provided to the compiled function is bound
   * to the top-level {@code this} of the evaluated code. For sanity,
   * this {@code imports} should first be initialized with a copy of the
   * properties of {@code sharedImports}, but nothing enforces this.
   */
  var sharedImports = Object.create(null);

  (function() {

    /**
     * The unsafe* variables hold precious values that must not escape
     * to untrusted code. When {@code eval} is invoked via {@code
     * unsafeEval}, this is a call to the indirect eval function, not
     * the direct eval operator.
     */
    var unsafeEval = eval;
    var UnsafeFunction = Function;

    /**
     * Fails if {@code programSrc} does not parse as a strict Program
     * production, or, almost equivalently, as a FunctionBody
     * production.
     *
     * <p>We use Crock's trick of simply passing {@code programSrc} to
     * the original {@code Function} constructor, which will throw a
     * SyntaxError if it does not parse as a FunctionBody. We used to
     * use Ankur's trick (need link) which is more correct, in that it
     * will throw if {@code programSrc} does not parse as a Program
     * production, which is the relevant question. However, the
     * difference -- whether return statements are accepted -- does
     * not matter for our purposes. And testing reveals that Crock's
     * trick executes over 100x faster on V8.
     */
    function verifyStrictProgram(programSrc) {
      UnsafeFunction('"use strict";' + programSrc);
    }

    /**
     * Fails if {@code exprSource} does not parse as a strict
     * Expression production.
     *
     * <p>To verify that exprSrc parses as a strict Expression, we
     * verify that (when followed by ";") it parses as a strict
     * Program, and that when surrounded with parens it still parses
     * as a strict Program. We place a newline before the terminal
     * token so that a "//" comment cannot suppress the close paren.
     */
    function verifyStrictExpression(exprSrc) {
      verifyStrictProgram(exprSrc + ';');
      verifyStrictProgram('( ' + exprSrc + '\n);');
    }

    /**
     * Make a virtual global object whose initial own properties are
     * a copy of the own properties of {@code sharedImports}.
     *
     * <p>Further uses of {@code copyToImports} to copy properties
     * onto this imports object will overwrite, effectively shadowing
     * the {@code sharedImports}. You should shadow by overwriting
     * rather than inheritance so that shadowing makes the original
     * binding inaccessible.
     *
     * <p>The returned imports object is extensible and all its
     * properties are configurable and non-enumerable. Once fully
     * initialized, the caller can of course freeze the imports
     * objects if desired. A reason not to do so it to emulate
     * traditional JavaScript intermodule linkage by side effects to a
     * shared (virtual) global object.
     *
     * <p>See {@code copyToImports} for the precise semantic of the
     * property copying.
     */
    function makeImports() {
      var imports = Object.create(null);
      copyToImports(imports, sharedImports);
      return imports;
    }

    /**
     * For all the own properties of {@code from}, copy their
     * descriptors to {@code imports}, except that each property
     * added to {@code imports} is unconditionally configurable
     * and non-enumerable.
     *
     * <p>By copying descriptors rather than values, any accessor
     * properties of {@code env} become accessors of {@code imports}
     * with the same getter and setter. If these do not use their
     * {@code this} value, then the original and any copied properties
     * are effectively joined. If the getter/setter do use their
     * {@code this}, when accessed with {@code imports} as the base,
     * their {@code this} will be bound to the {@code imports} rather
     * than {@code from}. If {@code from} contains writable value
     * properties, this will copy the current value of the property,
     * after which they may diverge.
     *
     * <p>We make these configurable so that {@code imports} can
     * be further configured before being frozen. We make these
     * non-enumerable in order to emulate the normal behavior of
     * built-in properties of typical global objects, such as the
     * browser's {@code window} object.
     */
    function copyToImports(imports, from) {
      Object.getOwnPropertyNames(from).forEach(function(name) {
        var desc = Object.getOwnPropertyDescriptor(from, name);
        desc.enumerable = false;
        desc.configurable = true;
        Object.defineProperty(imports, name, desc);
      });
      return imports;
    }

    /**
     * Make a frozen scope object which reflects all access onto
     * {@code imports}, for use by {@code with} to prevent
     * access to any {@code freeNames} other than those found on the.
     * {@code imports}.
     */
    function makeScopeObject(imports, freeNames) {
      var scopeObject = Object.create(null);
      Object.keys(freeNames).forEach(function(name) {
        var desc = Object.getOwnPropertyDescriptor(imports, name);
        if (!desc || desc.writable !== false || desc.configurable) {
          // If there is no own property, or it isn't a non-writable
          // value property, or it is configurable. Note that this
          // case includes accessor properties. The reason we wrap
          // rather than copying over getters and setters is so the
          // this-binding of the original getters and setters will be
          // the imports rather than the scopeObject.
          desc = {
            get: function() {
              if (name in imports) {
                var result = imports[name];
                if (typeof result === 'function') {
                  // If it were possible to know that the getter call
                  // was on behalf of a simple function call to the
                  // gotten function, we could instead return that
                  // function as bound to undefined. Unfortunately,
                  // without parsing (or possibly proxies?), that isn't
                  // possible.
                }
                return result;
              }
              // if it were possible to know that the getter call was on
              // behalf of a typeof expression, we'd return the string
              // "undefined" here instead. Unfortunately, without
              // parsing or proxies, that isn't possible.
              throw new ReferenceError('"' + name + '" not in scope');
            },
            set: function(newValue) {
              if (name in imports) {
                imports[name] = newValue;
              }
              throw new TypeError('Cannot set "' + name + '"');
            },
            enumerable: false
          };
        }
        desc.enumerable = false;
        Object.defineProperty(scopeObject, name, desc);
      });
      return Object.freeze(scopeObject);
    }


    /**
     * Like {@code compileExpr} but does not freeze the function it
     * returns.
     */
    function internalCompileExpr(exprSrc, opt_sourcePosition) {
      if (dirty) { fail('Initial cleaning failed'); }
      verifyStrictExpression(exprSrc);
      var freeNames = atLeastFreeVarNames(exprSrc);

      /**
       * Notice that the source text placed around {@code exprSrc}
       * <ul>
       * <li>brings no variable names into scope, avoiding any
       *     non-hygienic name capture issues, and
       * <li>does not introduce any newlines preceding exprSrc, so
       *     that all line number which a debugger might report are
       *     accurate wrt the original source text. And except for the
       *     first line, all the column numbers are accurate too.
       * </ul>
       */
      var wrapperSrc =
        '(function() { ' +
        // non-strict code, where this === scopeObject
        '  with (this) { ' +
        '    return function() { ' +
        '      "use strict"; ' +
        '      return ( ' +
        // strict code, where this === imports
        '        ' + exprSrc + '\n' +
        '      );\n' +
        '    };\n' +
        '  }\n' +
        '})';
      var wrapper = unsafeEval(wrapperSrc);

      function compiledCode(imports) {
        var scopeObject = makeScopeObject(imports, freeNames);
        return wrapper.call(scopeObject).call(imports);
      };
      Object.freeze(compiledCode.prototype);
      return compiledCode;
    }

    /**
     * Compiles {@code exprSrc} as a strict expression into a function
     * of an {@code imports}, that when called evaluates {@code
     * exprSrc} in a virtual global environment whose {@code this} is
     * bound to that {@code imports}, and whose free variables
     * refer only to the properties of that {@code imports}.
     *
     * <p>When SES is provided primitively, it should provide an
     * analogous {@code compileProgram} function that accepts a
     * Program and return a function that evaluates it to the
     * Program's completion value. Unfortunately, this is not
     * practical as a library without some non-standard support from
     * the platform such as a parser API that provides an AST.
     *
     * <p>Thanks to Mike Samuel and Ankur Taly for this trick of using
     * {@code with} together with RegExp matching to intercept free
     * variable access without parsing.
     *
     * <p>TODO(erights): Find out if any platforms have any way to
     * associate a file name and line number with eval'ed text, so
     * that we can do something useful with the optional {@code
     * opt_sourcePosition} to better support debugging.
     */
    function compileExpr(exprSrc, opt_sourcePosition) {
      var result = internalCompileExpr(exprSrc, opt_sourcePosition);
      return Object.freeze(result);
    }


    var directivePattern = (/^['"](?:\w|\s)*['"]$/m);

    /**
     * A stereotyped form of the CommonJS require statement.
     */
    var requirePattern = (/^(?:\w*\s*(?:\w|\$|\.)*\s*=)?\s*require\s*\(\s*['"]((?:\w|\$|\.|\/)+)['"]\s*\)$/m);

    /**
     * As an experiment, recognize a stereotyped prelude of the
     * CommonJS module system.
     */
    function getRequirements(modSrc) {
      var result = [];
      var stmts = modSrc.split(';');
      var stmt;
      var i = 0, ilen = stmts.length;
      for (; i < ilen; i++) {
        stmt = stmts[i].trim();
        if (stmt !== '') {
          if (!directivePattern.test(stmt)) { break; }
        }
      }
      for (; i < ilen; i++) {
        stmt = stmts[i].trim();
        if (stmt !== '') {
          var m = requirePattern.exec(stmt);
          if (!m) { break; }
          result.push(m[1]);
        }
      }
      return Object.freeze(result);
    }

    /**
     * A module source is actually any valid FunctionBody, and thus
     * any valid Program.
     *
     * <p>In addition, in case the module source happens to begin with
     * a streotyped prelude of the CommonJS module system, the
     * function resulting from module compilation has an additional
     * {@code "requirements"} property whose value is a list of the
     * module names being required by that prelude. These requirements
     * are the module's "immediate synchronous dependencies".
     *
     * <p>This {@code "requirements"} property is adequate to
     * bootstrap support for a CommonJS module system, since a loader
     * can first load and compile the transitive closure of an initial
     * module's synchronous depencies before actually executing any of
     * these module functions.
     *
     * <p>With a similarly lightweight RegExp, we should be able to
     * similarly recognize the {@code "load"} syntax of <a href=
     * "http://wiki.ecmascript.org/doku.php?id=strawman:simple_modules#syntax"
     * >Sam and Dave's module proposal for ES-Harmony</a>. However,
     * since browsers do not currently accept this syntax,
     * {@code getRequirements} above would also have to extract these
     * from the text to be compiled.
     */
    function compileModule(modSrc, opt_sourcePosition) {
      var moduleMaker = internalCompileExpr(
        '(function() {' + modSrc + '}).call(this)',
        opt_sourcePosition);
      moduleMaker.requirements = getRequirements(modSrc);
      return Object.freeze(moduleMaker);
    }

    /**
     * A safe form of the {@code Function} constructor, which
     * constructs strict functions that can only refer freely to the
     * {@code sharedImports}.
     *
     * <p>The returned function is strict whether or not it declares
     * itself to be.
     */
    function FakeFunction(var_args) {
      var params = [].slice.call(arguments, 0);
      var body = params.pop();
      body = String(body || '');
      params = params.join(',');
      var exprSrc = '(function(' + params + '\n){' + body + '})';
      return compileExpr(exprSrc)(sharedImports);
    }
    FakeFunction.prototype = UnsafeFunction.prototype;
    FakeFunction.prototype.constructor = FakeFunction;
    global.Function = FakeFunction;

    /**
     * A safe form of the indirect {@code eval} function, which
     * evaluates {@code src} as strict code that can only refer freely
     * to the {@code sharedImports}.
     *
     * <p>Given our parserless methods of verifying untrusted sources,
     * we unfortunately have no practical way to obtain the completion
     * value of a safely evaluated Program. Instead, we adopt a
     * compromise based on the following observation. All Expressions
     * are valid Programs, and all Programs are valid
     * FunctionBodys. If {@code src} parses as a strict expression,
     * then we evaluate it as an expression and correctly return its
     * completion value, since that is simply the value of the
     * expression.
     *
     * <p>Otherwise, we evaluate {@code src} as a FunctionBody and
     * return what that would return from its implicit enclosing
     * function. If {@code src} is simply a Program, then it would not
     * have an explicit {@code return} statement, and so we fail to
     * return its completion value.
     *
     * <p>When SES {@code eval} is provided primitively, it should
     * accept a Program and evaluate it to the Program's completion
     * value. Unfortunately, this is not possible on ES5 without
     * parsing.
     */
    function fakeEval(src) {
      try {
        verifyStrictExpression(src);
      } catch (x) {
        src = '(function() {' + src + '\n}).call(this)';
      }
      return compileExpr(src)(sharedImports);
    }

    if (TAME_GLOBAL_EVAL) {
      global.eval = fakeEval;
    }

    var defended = WeakMap();
    /**
     * To define a defended object is to freeze it and all objects
     * transitively reachable from it via transitive reflective
     * property and prototype traversal.
     */
    function def(node) {
      var defending = WeakMap();
      var defendingList = [];
      function recur(val) {
        if (val !== Object(val) || defended.get(val) || defending.get(val)) {
          return;
        }
        defending.set(val, true);
        defendingList.push(val);
        Object.freeze(val);
        recur(Object.getPrototypeOf(val));
        Object.getOwnPropertyNames(val).forEach(function(p) {
          if (typeof val === 'function' &&
              (p === 'caller' || p === 'arguments')) {
            return;
          }
          var desc = Object.getOwnPropertyDescriptor(val, p);
          recur(desc.value);
          recur(desc.get);
          recur(desc.set);
        });
      }
      recur(node);
      defendingList.forEach(function(obj) {
        defended.set(obj, true);
      });
      return node;
    }

    global.cajaVM = {
      log: function(str) {
        if (typeof console !== 'undefined' && 'log' in console) {
          // We no longer test (typeof console.log === 'function') since,
          // on IE9 and IE10preview, in violation of the ES5 spec, it
          // is callable but has typeof "object". See
          // https://connect.microsoft.com/IE/feedback/details/685962/
          //   console-log-and-others-are-callable-but-arent-typeof-function
          console.log(str);
        }
      },

      compileExpr: compileExpr,
      compileModule: compileModule,
      // compileProgram: compileProgram, // Cannot be implemented in ES5.1.
      eval: fakeEval,
      Function: FakeFunction,

      sharedImports: sharedImports,
      makeImports: makeImports,
      copyToImports: copyToImports
    };
    var extensionsRecord = extensions();
    Object.getOwnPropertyNames(extensionsRecord).forEach(function (p) {
      Object.defineProperty(cajaVM, p,
          Object.getOwnPropertyDescriptor(extensionsRecord, p));
    });
    // Move this down here so it is not available during the call to
    // extensions.
    global.cajaVM.def = def;

  })();

  var propertyReports = {};

  /**
   * Report how a property manipulation went.
   */
  function reportProperty(severity, status, path) {
    ses.updateMaxSeverity(severity);
    var group = propertyReports[status] || (propertyReports[status] = {
      severity: severity,
      list: []
    });
    group.list.push(path);
  }

  /**
   * Read the current value of base[name], and freeze that property as
   * a data property to ensure that all further reads of that same
   * property from that base produce the same value.
   *
   * <p>The algorithms in {@code ses.startSES} traverse the graph of
   * primordials multiple times. These algorithms rely on all these
   * traversals seeing the same graph. By freezing these as data
   * properties the first time they are read, we ensure that all
   * traversals see the same graph.
   *
   * <p>The frozen property should preserve the enumerability of the
   * original property.
   */
  function read(base, name) {
    var desc = Object.getOwnPropertyDescriptor(base, name);
    if (!desc) { return undefined; }
    if ('value' in desc && !desc.writable && !desc.configurable) {
      return desc.value;
    }

    var result = base[name];
    try {
      Object.defineProperty(base, name, {
        value: result, writable: false, configurable: false
      });
    } catch (ex) {
      reportProperty(ses.severities.NEW_SYMPTOM,
                     'Cannot be neutered',
                     '(a ' + typeof base + ').' + name);
    }
    return result;
  }

  /**
   * Initialize accessible global variables and {@code sharedImports}.
   *
   * For each of the whitelisted globals, we {@code read} its value,
   * freeze that global property as a data property, and mirror that
   * property with a frozen data property of the same name and value
   * on {@code sharedImports}, but always non-enumerable. We make
   * these non-enumerable since ES5.1 specifies that all these
   * properties are non-enumerable on the global object.
   */
  Object.keys(whitelist).forEach(function(name) {
    var desc = Object.getOwnPropertyDescriptor(global, name);
    if (desc) {
      var permit = whitelist[name];
      if (permit) {
        var value = read(global, name);
        Object.defineProperty(sharedImports, name, {
          value: value,
          writable: true,
          enumerable: false,
          configurable: false
        });
      }
    }
  });
  if (TAME_GLOBAL_EVAL) {
    Object.defineProperty(sharedImports, 'eval', {
      value: cajaVM.eval,
      writable: true,
      enumerable: false,
      configurable: false
    });
  }

  /**
   * The whiteTable should map from each path-accessible primordial
   * object to the permit object that describes how it should be
   * cleaned.
   *
   * <p>To ensure that each subsequent traversal obtains the same
   * values, these paths become paths of frozen data properties. See
   * the doc-comment on {@code read}.
   *
   * We initialize the whiteTable only so that {@code getPermit} can
   * process "*" and "skip" inheritance using the whitelist, by
   * walking actual superclass chains.
   */
  var whiteTable = WeakMap();
  function register(value, permit) {
    if (value !== Object(value)) { return; }
    if (typeof permit !== 'object') {
      return;
    }
    var oldPermit = whiteTable.get(value);
    if (oldPermit) {
      fail('primordial reachable through multiple paths');
    }
    whiteTable.set(value, permit);
    Object.keys(permit).forEach(function(name) {
      if (permit[name] !== 'skip') {
        var sub = read(value, name);
        register(sub, permit[name]);
      }
    });
  }
  register(sharedImports, whitelist);

  /**
   * Should the property named {@code name} be whitelisted on the
   * {@code base} object, and if so, with what Permit?
   *
   * <p>If it should be permitted, return the Permit (where Permit =
   * true | "*" | "skip" | Record(Permit)), all of which are
   * truthy. If it should not be permitted, return false.
   */
  function getPermit(base, name) {
    var permit = whiteTable.get(base);
    if (permit) {
      if (hop.call(permit, name)) { return permit[name]; }
    }
    while (true) {
      base = Object.getPrototypeOf(base);
      if (base === null) { return false; }
      permit = whiteTable.get(base);
      if (permit && hop.call(permit, name)) {
        var result = permit[name];
        if (result === '*' || result === 'skip') {
          return result;
        } else {
          return false;
        }
      }
    }
  }

  var cleaning = WeakMap();

  /**
   * Delete the property if possible, else try to poison.
   */
  function cleanProperty(base, name, path) {
    function poison() {
      throw new TypeError('Cannot access property ' + path);
    }
    var diagnostic;

    if (typeof base === 'function') {
      if (name === 'caller') {
        diagnostic = ses.makeCallerHarmless(base, path);
        // We can use a severity of SAFE here since if this isn't
        // safe, it is the responsibility of repairES5.js to tell us
        // so. All the same, we should inspect the reports on all
        // platforms we care about to see if there are any surprises.
        reportProperty(ses.severities.SAFE,
                       diagnostic, path);
        return true;
      }
      if (name === 'arguments') {
        diagnostic = ses.makeArgumentsHarmless(base, path);
        // We can use a severity of SAFE here since if this isn't
        // safe, it is the responsibility of repairES5.js to tell us
        // so. All the same, we should inspect the reports on all
        // platforms we care about to see if there are any surprises.
        reportProperty(ses.severities.SAFE,
                       diagnostic, path);
        return true;
      }
    }

    var deleted = void 0;
    var err = void 0;
    try {
      deleted = delete base[name];
    } catch (er) { err = er; }
    var exists = hop.call(base, name);
    if (deleted) {
      if (!exists) {
        reportProperty(ses.severities.SAFE,
                       'Deleted', path);
        return true;
      }
      reportProperty(ses.severities.SAFE_SPEC_VIOLATION,
                     'Bounced back', path);
    } else if (deleted === false) {
      reportProperty(ses.severities.SAFE_SPEC_VIOLATION,
                     'Strict delete returned false rather than throwing', path);
    } else if (err instanceof TypeError) {
      // This is the normal abnormal case, so leave it to the next
      // section to emit a diagnostic.
      //
      // reportProperty(ses.severities.SAFE_SPEC_VIOLATION,
      //                'Cannot be deleted', path);
    } else {
      reportProperty(ses.severities.NEW_SYMPTOM,
                     'Delete failed with' + err, path);
    }

    try {
      Object.defineProperty(base, name, {
        get: poison,
        set: poison,
        enumerable: false,
        configurable: false
      });
    } catch (cantPoisonErr) {
      try {
        // Perhaps it's writable non-configurable, it which case we
        // should still be able to freeze it in a harmless state.
        var value = Object.getOwnPropertyDescriptor(base, name).value;
        Object.defineProperty(base, name, {
          value: value === null ? null : void 0,
          writable: false,
          configurable: false
        });
      } catch (cantFreezeHarmless) {
        reportProperty(ses.severities.NOT_ISOLATED,
                       'Cannot be poisoned', path);
        return false;
      }
    }
    var desc2 = Object.getOwnPropertyDescriptor(base, name);
    if (desc2.get === poison &&
        desc2.set === poison &&
        !desc2.configurable) {
      try {
        var dummy2 = base[name];
      } catch (expectedErr) {
        if (expectedErr instanceof TypeError) {
          reportProperty(ses.severities.SAFE,
                         'Successfully poisoned', path);
          return true;
        }
      }
    } else if ((desc2.value === void 0 || desc2.value === null) &&
               !desc2.writable &&
               !desc2.configurable) {
      reportProperty(ses.severities.SAFE,
                     'Frozen harmless', path);
      return false;
    }
    reportProperty(ses.severities.NEW_SYMTOM,
                   'Failed to be poisoned', path);
    return false;
  }

  /**
   * Assumes all super objects are otherwise accessible and so will be
   * independently cleaned.
   */
  function clean(value, prefix) {
    if (value !== Object(value)) { return; }
    if (cleaning.get(value)) { return; }
    cleaning.set(value, true);
    Object.getOwnPropertyNames(value).forEach(function(name) {
      var path = prefix + (prefix ? '.' : '') + name;
      var p = getPermit(value, name);
      if (p) {
        if (p === 'skip') {
          reportProperty(ses.severities.SAFE,
                         'Skipped', path);
        } else {
          var sub = read(value, name);
          clean(sub, path);
        }
      } else {
        cleanProperty(value, name, path);
      }
    });
    Object.freeze(value);
  }
  clean(sharedImports, '');


  Object.keys(propertyReports).sort().forEach(function(status) {
    var group = propertyReports[status];
    ses.logger.reportDiagnosis(group.severity, status, group.list);
  });

  ses.logger.reportMax();

  if (ses.ok()) {
    // We succeeded. Enable safe Function, eval, and compile* to work.
    dirty = false;
    ses.logger.log('initSES succeeded.');
  } else {
    ses.logger.error('initSES failed.');
  }
};
