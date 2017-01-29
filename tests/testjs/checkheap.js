

var Tester;
var stdheap;

(function(global){
  "use strict";

  function getActual(path) {
    switch (typeof path) {
    case 'number':
    case 'boolean':
    case 'undefined': { return path; }
    case 'object': {
      if (path === null) { return null; }
      if (Tester.isArray(path)) {
        Tester.assert(path.length >= 1);
        switch (path[0]) {
        case '@quote': { return path[1]; }
        default: { throw Tester.assert(false, "unrecognized: ", path[0]); }
        }
      }
      throw Tester.assert(false, "unexpected: ", path);
    }
    case 'string': {
      if (path === '-Infinity') {
        // Special case because it's the one primitive value that is
        // neither representable in JSON nor is a global variable
        return -Infinity;
      }
      var names = path.split('.');
      Tester.assert(names.length >= 1);
      var result = global;
      var i = 0;
      if (names[0] === 'this') { i = 1; }
      for (var len = names.length; i < len; i++) {
        var name = names[i];
        Tester.assert(result === Object(result));
      if (!Tester.hop.call(result, name)) { return undefined; }
        result = result[name];
      }
      Tester.assert(Tester.eq(result, (1,eval)(path)),
                    "doesn't match: ", path);
      return result;
    }
    default: {
      if (path === null) { return null; }
      throw Tester.assert(false, "surprising: ", path);
    }
    }
  }

  Tester.keys(stdheap).forEach(function(path) {
    var record = stdheap[path];
    Tester.assert(path === record.path);
    var section = record.section;
    var check = Tester.makeCheck(path + ' (' + section + ') ');

    var actual = getActual(path);
    if (!check("doesn't exist",
               true, actual !== undefined)) { return; }
    var clazz = record['[[Class]]'];
    if (clazz !== '?') {
      check('[[Class]]',
            '[object ' + clazz + ']', Tester.toString.call(actual));
    }
    var protoName = record['[[Prototype]]'];
    if (protoName !== '?') {
      var protoShould = getActual(protoName);
      var protoDid = Tester.getPrototypeOf(actual);
      check('[[Prototype]]',
            protoShould, protoDid,
            protoName);
    }
    var typShould = record['typeof'];
    if (typShould !== '?') {
      check('typeof',
           typShould, typeof actual);
    }
    var extShould = record.extensible;
    if (extShould !== '?') {
      check('extensible',
            extShould, Tester.isExtensible(actual));
    }

    var pdmap = record.pdmap;
    if (Tester.hop.call(actual, 'prototype') &&
        !Tester.hop.call(pdmap, 'prototype') &&
        record['[[Class]]'] === 'Function' &&
        record.section.split('.')[0] === '15') {
      check("None of the built-in functions described in (15) " +
            "shall have a prototype property unless otherwise " +
            "specified ...",
            false, true);
    }

    Tester.keys(pdmap).forEach(function(name) {
      var shouldPD = pdmap[name];
      var didPD = Tester.getOwnPropertyDescriptor(actual, name);
      if (!check('.' + name + ' absent',
                 !!shouldPD, !!didPD)) {
        return;
      }
      check('.' + name + ' configurable?',
            '' + shouldPD.configurable, '' + didPD.configurable);
      check('.' + name + ' enumerable?',
            '' + shouldPD.enumerable, '' + didPD.enumerable);
      if ('value' in shouldPD) {
        if (!check('.' + name + ' should be data property',
                  true, 'value' in didPD)) { return; }
        check('.' + name + ' writable?',
              '' + shouldPD.writable, '' + didPD.writable);
        var shouldValue = getActual(shouldPD.value);
        var didValue1 = didPD.value;
        var didValue2 = actual[name];
        check('.' + name + " doesn't have claimed value",
              didValue1, didValue2);
        check('.' + name + " doesn't have expected value",
              shouldValue, didValue1);
      } else {
        Tester.assert('get' in shouldPD);
        if (!check('.' + name + ' should be accessor property',
                  true, 'get' in didPD)) { return; }

      }
    });

  });

})(this);
