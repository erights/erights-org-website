/*
The contents of this file are subject to the Electric Communities E Open
Source Code License Version 1.0 (the "License"); you may not use this file
except in compliance with the License. You may obtain a copy of the License
at http://www.communities.com/EL/.

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is the Distributed E Language Implementation, released
July 20, 1998.

The Initial Developer of the Original Code is Electric Communities.
Copyright (C) 1998 Electric Communities. All Rights Reserved.

Contributor(s): ______________________________________.
*/

/*
  A YACC Grammar for E.

  by Chip Morningstar
  based on a non-YACC grammar by Mark Miller
  modified by others, especially MarkM (see cvs)

  This grammar is for the non-kernel version of E.
*/
%{
package org.erights.e.elang.syntax;

import org.erights.e.develop.exception.NestedException;
import org.erights.e.develop.exception.PrintStreamWriter;
import org.erights.e.develop.assertion.T;
import org.erights.e.elang.evm.ENode;
import org.erights.e.elang.evm.NounExpr;
import org.erights.e.elang.evm.Pattern;
import org.erights.e.elang.evm.EExpr;
import org.erights.e.elib.base.ValueThunk;
import org.erights.e.elib.prim.StaticMaker;
import org.erights.e.elib.tables.ConstList;
import org.erights.e.elib.tables.ConstMap;
import org.erights.e.elib.tables.IdentityCacheTable;
import org.erights.e.elib.tables.Twine;
import org.erights.e.elib.oldeio.TextWriter;
import org.quasiliteral.astro.Astro;
import org.quasiliteral.astro.AstroSchema;
import org.quasiliteral.astro.BaseSchema;
import org.quasiliteral.syntax.SyntaxException;
import org.quasiliteral.syntax.LexerFace;
import org.quasiliteral.text.EYaccFixer;

import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInput;
import java.io.ObjectInputStream;
%}

/* The magical end-of-line token, not considered whitespace */
%token EOL

/**
 * When an EOL occurs at top level (ie, between top-level
 * expressions), then the lexer returns an EOTLU (end of top level
 * unit). yylex() then converts this to either an EOL or an EOFTOK
 * depending on whether we wish to parse the whole input at once or
 * only one top-level unit (eg, expression) at a time. Therefore, the
 * grammar never sees an EOTLU.
 */
%token EOTLU

/* Categorical terminals */
%token LiteralInteger   /* precision unlimited */
%token LiteralFloat64   /* IEEE double precision */
%token LiteralChar      /* Unicode */
%token LiteralString    /* Double quoted */
%token LiteralTwine     /* quasi-quoted without holes.  Not yet used */

%token ID               /* like Java's ident, but no "$"s, and not keyword */
%token VerbAssign       /* ID "=" */
%token QuasiOpen        /* ("`" char*) | (char*), up to hole */
%token QuasiClose       /* QuasiOpen "`" */
%token DollarIdent      /* "$" ID */
%token AtIdent          /* ("@" ID) | "@_" */
%token DollarOpen       /* "${" */
%token AtOpen           /* "@{" */
%token URI              /* "<" protocol ":" body ">" */
%token URIStart         /* "<" protocol ":" */
%token DocComment       /* /-*-* ... *-/ (without the '-'s) */
%token BodyStartWord    /* defmacro'd keyword.  Not yet used */
%token BodyNextWord     /* defmacro'd keyword.  Not yet used */
%token VTableStartWord  /* defmacro'd keyword.  Not yet used */
%token VTableNextWord   /* defmacro'd keyword.  Not yet used */

/* Keywords */
%token BIND BREAK CATCH CONTINUE DEF
%token ELSE ESCAPE EXTENDS
%token FINALLY FOR GUARDS IF IMPLEMENTS IN INTERFACE
%token MATCH META METHOD PRAGMA RETURN SWITCH
%token THUNK TO TRY VAR WHEN WHILE _

/* Pseudo-reserved (Reserved, but used in reserved productions) */
%token ACCUM DELEGATE MODULE ON SELECT THROWS

/* Reserved Keywords */
%token ABSTRACT AN AS ASSERT ATTRIBUTE
%token BE BEGIN BEHALF BELIEF BELIEVE BELIEVES
%token CASE CLASS CONST CONSTRUCTOR
%token DECLARE DEFAULT DEFINE DEFMACRO
%token DELICATE DEPRECATED DISPATCH DO
%token ENCAPSULATE ENCAPSULATED ENCAPSULATES
%token END ENSURE ENUM EVENTUAL EVENTUALLY
%token EXPORT FACET FORALL FUNCTION GIVEN
%token HIDDEN HIDES INLINE IS
%token KNOW KNOWS LAMBDA LET METHODS
%token NAMESPACE NATIVE
%token OBEYS OCTET ONEWAY OPERATOR
%token PACKAGE PRIVATE PROTECTED PUBLIC
%token RAISES RELIANCE RELIANT RELIES RELY REVEAL
%token SAKE SIGNED STATIC STRUCT
%token SUCHTHAT SUPPORTS SUSPECT SUSPECTS SYNCHRONIZED
%token THIS TRANSIENT TRUNCATABLE TYPEDEF
%token UNSIGNED UNUM USES USING UTF8 UTF16
%token VIRTUAL VOLATILE WSTRING


/* Multi-Character Operators */
%token OpLAnd           /* && */
%token OpLOr            /* || */
%token OpSame           /* == */
%token OpNSame          /* != */
%token OpButNot         /* &! */
%token OpLeq            /* <= */
%token OpABA            /* <=> */
%token OpGeq            /* >= */
%token OpThru           /* .. */
%token OpTill           /* ..! */
%token OpAsl            /* << */
%token OpAsr            /* >> */
%token OpFlrDiv         /* // */
%token OpMod            /* %% */
%token OpPow            /* ** */

%token OpAss            /* :=  */
%token OpAssAdd         /* +=  */
%token OpAssAnd         /* &=  */
%token OpAssAprxDiv     /* /=  */
%token OpAssFlrDiv      /* //= */
%token OpAssAsl         /* <<= */
%token OpAssAsr         /* >>= */
%token OpAssRemdr       /* %= XXX We should probably phase out '%' and '%='. */
%token OpAssMod         /* %%= */
%token OpAssMul         /* *=  */
%token OpAssOr          /* |=  */
%token OpAssPow         /* **= */
%token OpAssSub         /* -=  */
%token OpAssXor         /* ^=  */

/* Other funky tokens */
%token Send             /* <- */
%token OpWhen           /* -> */
%token MapsTo           /* => */
%token MatchBind        /* =~ */
%token MisMatch         /* !~ */
%token OpScope          /* :: */

/* Non-token Kernel-E Term-tree tag names (ie, functor names) */

%token AssignExpr
%token CallExpr
%token DefineExpr
%token EscapeExpr
%token HideExpr
%token IfExpr
%token LiteralExpr
%token MatchBindExpr
%token NounExpr
%token ObjectExpr
%token QuasiLiteralExpr
%token QuasiPatternExpr
%token MetaStateExpr
%token MetaContextExpr
%token SeqExpr
%token SlotExpr
%token MetaExpr
%token CatchExpr
%token FinallyExpr

%token FinalPattern
%token VarPattern
%token SlotPattern
%token ListPattern
%token CdrPattern
%token IgnorePattern
%token SuchThatPattern
%token QuasiLiteralPatt
%token QuasiPatternPatt

%token EScript
%token EMethod
%token EMatcher


/* Grammar follows */
%%


/**
 * JAY - added EOLs to start production so we can accept
 * "comment-only" programs.
 */
start:
        br                                      { myOptResult = null; }
 |      eExpr                                   { myOptResult = (EExpr)$1; }

        /* For moving towards real modules */
 |      br MODULE litString EOL eExpr           { b.reserved($2,"module"); }

        /* Kludges to parse other productions at the top */
 |      MatchBind pattern                       { myOptResult = (Pattern)$2; }
 ;

/**
 *
 */
ejector:
        BREAK                           { $$ = b.get__BREAK(); }
 |      CONTINUE                        { $$ = b.get__CONTINUE(); }
 |      RETURN                          { $$ = b.get__RETURN(); }
 ;

/*
********************************************
**               Expressions
********************************************
*/

/**
 *
 */
eExpr:
        br seqs br                      { $$ = $2; }
 ;

/**
 * Newline separated expressions are don't-care associative.
 * <p>
 * First evaluates left, then evaluates to the outcome of right.
 */
seqs:
        seq
 |      seqs EOLs seq                   { $$ = b.sequence($1, $3); }
 ;

/**
 * ';'-separated expressions are don't-care associative.
 */
seq:
        chunk
 |      seq ';'
 |      seq ';' chunk                   { $$ = b.sequence($1, $3); }
 ;

/**
 * "Chunk" is a stupid name, but I couldn't think of anything.
 * <p>
 * "def <noun>" without a right hand side is a forward declaration.
 * It introduces the name into scope bound to a promise for what it
 * will be.
 * <p>
 * Except for assign, these are typically used in a statement-like
 * fashion -- evaluated for effect only -- but the forward declataion
 * does have a useful value: the Resolver.
 * <p>
 * oFuncType appears here since it needs to be terminated by an EOL or ';'
 */
chunk:
        assign
 |      DEF noun                        { $$ = b.forward($2); }
 |      ejector                         { $$ = b.ejector($1); }
 |      ejector '(' ')'                 { $$ = b.ejector($1); }
 |      ejector assign                  { $$ = b.ejector($1, $2); }
 |      '^' assign                      { b.pocket($1,"smalltalk-return");
                                          $$ = b.ejector(b.get__RETURN(),$2);}
 |                 oFuncType            { $$ = b.doco("",$1); }
 |      DocComment oFuncType            { $$ = b.doco($1,$2); }
 |      docoretdef
 ;

/**
 * When an ejector keyword or "^" appears between the DocComment and the
 * definition expression, treat it as if the ejector appeared first.
 */
docoretdef:
        DocComment     '^' postdocodef  { b.pocket($1,"smalltalk-return");
                                          $$ = b.ejector(b.get__RETURN(),
                                                         b.doco($1,$3)); }
 |      DocComment ejector postdocodef  { $$ = b.ejector($2,
                                                         b.doco($1,$3)); }
 |      DocComment     '^' oFuncType    { b.pocket($1,"smalltalk-return");
                                          $$ = b.ejector(b.get__RETURN(),
                                                         b.doco($1,$3)); }
 |      DocComment ejector oFuncType    { $$ = b.ejector($2,
                                                         b.doco($1,$3)); }
 ;



/**
 * Assignment (:=, <op>=, and >>=) and definition are right
 * associative.  The invalid cases of the left hand side of assignment
 * are caught after parsing.  See documentation for transformations.
 *
 * When the pattern-part of a define is a binder or a varNamer, then
 * the "def" can be left out.
 */
nAssign:
        assign                          { $$ = b.list($1); }
 |      plural
 ;
assign:
        cond
 |      cond OpAss      assign          { $$ = b.assign($1,     $3); }
 |      cond assignop   nAssign         { $$ = b.update($1, $2, $3); }

 |      DEF pattern OpAss assign        { $$ = b.define($2, $4); }
 |      binder      OpAss assign        { $$ = b.define($1, $3); }
 |      varNamer    OpAss assign        { $$ = b.define($1, $3); }
 ;

/**
 * || is don't-care associative
 */
cond:
        condAnd
 |      cond OpLOr condAnd              { $$ = b.condOr($1, $2, $3); }
 ;


/**
 * && is don't-care associative
 */
condAnd:
        comp
 |      condAnd OpLAnd comp             { $$ = b.condAnd($1, $2, $3); }
 ;


/**
 * ==, !=, &, |, ^, =~, and !~ are all non associative with each
 * other.  & and |, normally used for associative operations, are each
 * made associative with themselves. None of the others even associate
 * with themselves. Perhaps ^ should?
 */
comp:
        order
 |      order OpSame   order            { $$ = b.same($1, $2, $3); }
 |      order OpNSame  order            { $$ = b.not($2, b.same($1, $2, $3)); }
 |      conjunction
 |      disjunction
 |      order '^'      nOrder           { $$ = b.call($1, $2,"xor", $3); }
 |      order OpButNot nOrder           { $$ = b.call($1, $2,"butNot", $3); }

 |      order MatchBind pattern         { $$ = b.matchBind($1, $2, $3); }
 |      order MisMatch  pattern         { $$ = b.not($2,
                                                     b.matchBind($1,$2,$3)); }
 ;

conjunction:
        order '&' nOrder                { $$ = b.call($1, $2,"and", $3); }
 |      conjunction '&' nOrder          { $$ = b.call($1, $2,"and", $3); }
 ;
disjunction:
        order '|' nOrder                { $$ = b.call($1, $2,"or", $3); }
 |      disjunction '|' nOrder          { $$ = b.call($1, $2,"or", $3); }
 ;

/**
 * &lt;, &lt;= &lt;=&gt;, &gt;=, &gt; are all non associative.
 * <p>
 * &gt; is not listed as a continuation operator, because it also has
 * a role in closing a calculated URI expression.  ELexer must handle
 * its use as a continuation specially.
 */
nOrder:
        order                           { $$ = b.list($1); }
 |      plural
 ;
order:
        interval
 |      interval '<'   interval         { $$ = b.lessThan($1, $2, $3); }
 |      interval OpLeq interval         { $$ = b.leq($1, $2, $3); }
 |      interval OpABA interval         { $$ = b.asBigAs($1, $2, $3); }
 |      interval OpGeq interval         { $$ = b.geq($1, $2, $3); }
 |      interval '>'   interval         { $$ = b.greaterThan($1, $2, $3); }

 /* interval would be accepted here, but for readability we insist on a
    postfix
 |      interval ':' guard              { b.pocket($2,"cast");
                                          $$ = b.cast($3, $2, $1); }
 */
 |      postfix ':' guard               { b.pocket($2,"cast");
                                          $$ = b.cast($3, $2, $1); }
 ;

/**
 * .. and ..! are both non associative (no plural form)
 */
interval:
        shift
 |      shift OpThru shift              { $$ = b.thru($1, $2, $3); }
 |      shift OpTill shift              { $$ = b.till($1, $2, $3); }
 ;


/**
 * << and >> are left associative (no plural form)
 */
shift:
        add
 |      shift OpAsl nAdd        { $$ = b.call($1, $2,"shiftLeft", $3); }
 |      shift OpAsr nAdd        { $$ = b.call($1, $2,"shiftRight", $3); }
 ;


/**
 * + and - are left associative
 */
nAdd:
        add                     { $$ = b.list($1); }
 |      plural
 ;
add:
        mult
 |      add '+' nMult            { $$ = b.call($1, $2,"add", $3); }
 |      add '-' nMult            { $$ = b.call($1, $2,"subtract", $3); }
 ;


/**
 * *, /, //, %, and %% are left associative
 *
 * XXX We should probably phase out '%' and '%='.
 */
nMult:
        mult                    { $$ = b.list($1); }
 |      plural
 ;
mult:
        pow
 |      mult '*'      nPow      { $$ = b.call($1, $2,"multiply", $3); }
 |      mult '/'      nPow      { $$ = b.call($1, $2,"approxDivide", $3); }
 |      mult OpFlrDiv nPow      { $$ = b.call($1, $2,"floorDivide", $3); }
 |      mult '%'      nPow      { $$ = b.call($1, $2,"remainder", $3); }
 |      mult OpMod    nPow      { $$ = b.mod($1, $2, $3); }
 ;


/**
 * ** is non-associative
 */
nPow:
        pow                     { $$ = b.list($1); }
 |      plural
 ;
pow:
        prefix
 |      prefix OpPow nPrefix    { $$ = b.call($1, $2,"pow", $3); }
 ;


/**
 * Unary prefix !, ~, &, *, and - are non associative.
 * <p>
 * Unary prefix !, ~, &, and * bind less tightly than unary postfix.
 * Unary prefix -, because it will often be mistaken for part of a literal
 * number rather than an operator, is not combinable with unary postfix, in
 * order to avoid the following surprise:
 * <pre>    -3.pow(2) ==> -9</pre>
 * If <tt>-3</tt> were a literal, the answer would be <tt>9</tt>. So, in E, you
 * must say either <tt>(-3).pow(2)</tt> or <tt>-(3.pow(2))</tt> to disambiguate
 * which you mean.
 */
nPrefix:
        prefix                  { $$ = b.list($1); }
 |      plural
 ;
prefix:
        postfix
 |      '!' postfix             { $$ = b.call($2, $1,"not", b.list()); }
 |      '~' postfix             { $$ = b.call($2, $1,"complement", b.list());}
 |      '&' postfix             { $$ = b.slotExpr($1, $2); }
 |      '*' postfix             { b.pocket($1,"unary-star");
                                  $$ = b.call($2, $1,"getValue", b.list()); }
 |      '-' prim                { $$ = b.call($2, $1,"negate", b.list()); }
 ;

/**
 * All calls and sends are left associative, but split into postfix and
 * call to resolve an ambiguity.
 */
postfix:
        call
 |      postfix '.'  vcurry             { $$ = b.callFacet($1, $3); }
 |      postfix Send vcurry             { $$ = b.sendFacet($1, $3); }

 |      postfix OpScope prop            { $$ = b.propValue($1, $3); }
 |      postfix OpScope '&' prop        { $$ = b.propSlot($1, $4); }
 |      metaoid OpScope prop            { $$ = b.doMetaProp($1, $3); }

 |      postfix Send OpScope prop       { $$ = b.sendPropValue($1, $4); }
 |      postfix Send OpScope '&' prop   { $$ = b.sendPropSlot($1, $5); }
 ;

/**
 * Disambiguate "foo.name(args)" into being a single call rather than
 * being equivalent to "(foo.name)(args)".  If the following
 * production were folded into the above "postfix", we would indeed
 * have this ambiguity.
 * <p>
 * We use parenArgsTail rather than parenArgs in one place below so
 * that we can capture the source position of the '('.
 */
call:
        prim

 |      call          '(' parenArgsTail { $$ = b.call($1, $2,"run", $3); }
 |      postfix '.'  verb parenArgs     { $$ = b.call($1, $3, $4); }
 |      postfix       '[' argList ']'   { $$ = b.call($1, $2,"get", $3); }
 |      postfix Send verb parenArgs     { $$ = b.send($1, $3, $4); }
 |      postfix Send      parenArgs     { $$ = b.send($1, $2,"run", $3); }

 |      metaoid           parenArgs     { $$ = b.doMeta($1, $1,"run", $2); }
 |      metaoid '.'  verb parenArgs     { $$ = b.doMeta($1, $3, $4); }
 |      metaoid       '[' argList ']'   { $$ = b.doMeta($1, $2,"get", $3); }
 |      metaoid Send verb parenArgs     { $$ = b.doMetaSend($1, $3, $4); }
 |      metaoid Send      parenArgs     { $$ = b.doMetaSend($1, $2,"run", $3);}

 |      accumExpr
 ;

/**
 *
 */
literal:
        LiteralInteger                          { $$ = b.literal($1); }
 |      LiteralFloat64                          { $$ = b.literal($1); }
 |      LiteralChar                             { $$ = b.literal($1); }
 |      litString                               { $$ = b.literal($1); }
 ;

/**
 * A no-parse-ambiguity-possible expression.
 */
prim:
        literal
 |      nounExpr

 |      URI                                     { $$ = b.uriExpr($1); }
 |      URIStart add '>'                        { $$ = b.uriExpr($1,$2); }
/* |    '<' parenExpr ':' add '>'               {b.reserved($3,"calc-uri");} */

 |      quasiParser quasiExpr                   { $$ = b.quasiExpr($1,$2); }

 |      parenExpr
 |      '[' exprList ']'                        { $$ = b.tuple($2); }
 |      '[' maps ']'                            { $$ = b.map($2); }

 |      body                                    { $$ = b.hide($1); }

 |      ESCAPE pattern body optHandler          { $$ = b.escape($2,$3,$4); }

 |      WHILE parenExpr body optHandler         { $$ = b.whilex($2,$3,$4); }

 |      SWITCH parenExpr caseList               { $$ = b.switchx($2,$3); }

 |      TRY body catchList finallyClause        { $$ = b.tryx($2,$3,$4); }

 |      forExpr
 |      whenExpr
 |      ifExpr

 |      macro

 |      SELECT parenExpr caseList               { b.reserved($1,"select"); }
 |      docodef
 ;

/**
 * A definition expression including an optional DocComment
 */
docodef:
                   postdocodef          { $$ = b.doco("",$1); }
 |      DocComment postdocodef          { $$ = b.doco($1,$2); }
 ;

/**
 * A definition expression that may be optionally preceded by a DocComment
 */
postdocodef:
        defName script                  { $$ = ((ObjDecl)$2).withOName($1); }
 |      THUNK body                      { /* doesn't bind __return */
                                          $$ = b.thunkDecl($1,$2); }
 |      _ funcHead body                 { b.pocket($1,"anon-lambda");
                                          /* doesn't bind __return */
                                          $$ = b.methDecl($2, $3, false)
                                                .withOName("_"); }
 |      _ body                          { b.pocket($1,"anon-lambda");
                                          /* doesn't bind __return */
                                          $$ = b.thunkDecl($1,$2); }
 |      whenClosure
 |      INTERFACE oName typeParams guards iDeclTail '{' br mTypeList '}'
                                        { $$ = b.oType("",$2,$4,$5,$8); }
 ;

/**
 *
 */
whenClosure:
        OpWhen oName '(' paramList ')' resultGuard body
                                { b.reserved($1,"whenClosure");
                                  $$ = b.whenClosure($2,$3,$4,$6,$7); }
 |      OpWhen       '(' paramList ')' resultGuard body
                                { b.reserved($1,"whenClosure");
                                  $$ = b.whenClosure(b.ignore(),$2,$3,$5,$6); }
 ;

/**
 *
 */
script:
        typeParams oDeclTail vTable     { $$ = ((ObjDecl)$2).withScript($3); }
 |      typeParams funcHead body        { /* binds __return */
                                          $$ = b.methDecl($2, $3, true); }
 ;


/**
 * Evaluates to the binding of this name in the current scope
 */
nounExpr:
        noun                            { $$ = noun($1); }
 |      dollarHole                      { $$ = b.quasiLiteralExpr($1); }
 |      atHole                          { $$ = b.quasiPatternExpr($1); }
 ;

dollarHole:
        DollarOpen LiteralInteger '}'   { $$ = $2; }
 |      '$' LiteralInteger              { $$ = $2; }
 |      '$' '$'                         { $$ = null; }
 ;

atHole:
        AtOpen LiteralInteger '}'       { $$ = $2; }
 |      '@' LiteralInteger              { $$ = $2; }
 ;

/**
 * Control constructs often take their expression in parens, so this
 * case is broken out.
 */
parenExpr:
        '(' eExpr ')'                   { $$ = $2; }
 ;

/**
 * "if" expressions require curlies around their blocks, but "else if"
 * is accepted directly.
 */
ifExpr:
        IF parenExpr body                       { $$ = b.ifx($2, $3); }
 |      IF parenExpr body ELSE ifExpr           { $$ = b.ifx($2, $3, $5); }
 |      IF parenExpr body ELSE body             { $$ = b.ifx($2, $3, $5); }
 ;

/**
 *
 */
forExpr:
        FOR iterPattern IN assign body optHandler { $$ = b.forx($2,$4,$5,$6); }
 /* XXX Why does this create conflicts?
 |      WHEN iterPattern IN assign body           { b.reserved($3,"when-in"); }
 */
 ;


/**
 *
 */
whenExpr:
        WHEN whenHead body catches finallyClause { $$ = b.when($2,$3,$4,$5); }
 |      WHEN whenHead body                       { yyerror("missing catch"); }
 ;

/**
 * XXX The 'macroArg' below should be turned into a 'macroArgList' (with
 * the obvious definition) but this creates undiagnosed shift/reduce
 * conflicts.  Need to figure out why.
 */
macro:
        BodyStartWord   macroArg body   restMacro
                                        { $$ = b.macro($1, $2, $3, $4); }
 |      VTableStartWord macroArg vTable restMacro
                                        { $$ = b.macro($1, $2, $3, $4); }
 ;

restMacro:
        /*empty*/                       { $$ = null; }
        BodyNextWord   macroArg body   restMacro
                                        { $$ = b.macro($1, $2, $3, $4); }
 |      VTableNextWord macroArg vTable restMacro
                                        { $$ = b.macro($1, $2, $3, $4); }
 ;

/**
 * XXX The 'parenExpr' below should be 'parenArgs', but this creates
 * an undiagnosed shift/reduce conflict.  Need to figure out why.
 */
macroArg:
        /*empty*/                       { $$ = null; }
 |      parenExpr
 |      pattern
 ;


quasiParser:
        /* empty */                     { $$ = noun("simple__quasiParser"); }
 |      ident                   { $$ = noun(b.mangle($1,
                                                     "__quasiParser")); }
 |      parenExpr
 ;

quasiExpr:
        QuasiClose                      { $$ = b.list($1); }
 |      innerExprs QuasiClose           { $$ = b.with($1, $2); }
 ;

innerExprs:
        QuasiOpen innerExpr             { $$ = b.list($1, $2); }
 |      innerExprs QuasiOpen innerExpr  { $$ = b.with(b.with($1, $2), $3); }
 ;

innerExpr:
        DollarIdent                     { $$ = b.dollarNoun($1); }
 |      DollarOpen eExpr '}'            { $$ = $2; }
 ;


/**
********************************************
**               Expression Lists
********************************************
*/

parenArgs:
        '(' parenArgsTail               { $$ = $2; }
 ;

parenArgsTail:
        argList ')'
 |      parenArgsTail whenClosure       { $$ = b.with($1, $2); }
 /* XXX Why do these create conflicts?
 |      parenArgsTail '(' argList ')'   { b.reserved($2,"more-args"); }
 |      parenArgsTail body              { b.pocket(b.NO_POSER,"block-args");
                                          $$ = b.with($1,
                                                      b.thunkDecl(null,$2)); }
 |      parenArgsTail docodef           { b.pocket(b.NO_POSER,"lambda-args");
                                          $$ = b.with($1, $2); }
 */
 ;

/**
 * Used to implement Tyler's weird and wonderful n-ary overloading of
 * operators.
 * <p>
 * Plural is for the 0 or >= 2 cases, since eExpr itself already
 * covers the 1-ary case..  We call it plural, because those are the
 * plural cases in english.
 */
plural:
        '(' ')'                         { $$ = b.list(); }
 |      '(' chunk ',' args ')'          { $$ = b.append(b.list($2),$4); }
 |      '(' maps ')'                    { b.pocket($2,"map-tail");
                                          $$ = b.list(b.map($2)); }
 ;

/**
 * Zero or more expressions (positional arguments) followed (if
 * map-tail is enabled) by zero or more map associations (typically
 * name-based arguments).
 * <p>
 * Correct handling of terminal commas on args, exprLists, and maps
 * thanks to Jon Leonard and Kevin Reid.
 */
argList:
        emptyBr
 |      args
 ;
args:
        exprs
 |      exprs ','
 |      exprs ',' maps                  { b.pocket($2,"map-tail");
                                          $$ = b.with($1, b.map($3)); }
 |                maps                  { b.pocket(b.NO_POSER,"map-tail");
                                          $$ = b.list(b.map($1)); }
 ;

exprList:
        emptyBr
 |      chunk                           { $$ = b.list($1); }
 |      exprs ',' chunk                 { $$ = b.with($1, $3); }
 |      exprs ','
 ;
exprs:
        chunk                           { $$ = b.list($1); }
 |      exprs ',' chunk                 { $$ = b.with($1, $3); }
 ;


maps:
        map                             { $$ = b.list($1); }
 |      maps ',' map                    { $$ = b.with($1, $3); }
 |      maps ','
 ;
map:
        chunk MapsTo chunk              { $$ = b.assoc($1, $3); }
 |      br    MapsTo nounExpr           { b.pocket($2,"exporter");
                                          $$ = b.exporter($3); }
 |      br    MapsTo '&' nounExpr       { b.pocket($2,"exporter");
                                          $$ = b.exporter(b.slotExpr($3,$4)); }
 |      br    MapsTo DEF noun           { b.pocket($2,"exporter");
                                          b.reserved($3,"Forward exporter"); }
 ;


/**
********************************************
**               Patterns
********************************************
*/

/**
 * 'for pattern in' expands to 'for _ => pattern in'
 */
iterPattern:
                       pattern          { $$ = b.assoc(b.ignore(), $1); }
 |      pattern MapsTo pattern          { $$ = b.assoc($1, $3); }
 ;


pattern:
        listPatt
 |      listPatt '?' order                      { $$ = b.suchThat($1, $3); }

 |      metaoid parenExpr MapsTo pattern        { b.reserved($3,
                                                             "meta pattern"); }
 ;

listPatt:
        eqPatt
 |      '[' patternList ']'                     { $$ = b.listPattern($2); }
 |      '[' patternList ']' '+' listPatt        { $$ = b.cdrPattern($2, $5); }

 |      '[' mapPatternList ']'                  { $$ = b.mapPattern($2,null); }
 |      '[' mapPatternList ']' '|' listPatt     { $$ = b.mapPattern($2, $5); }
 ;

eqPatt:
        quasiPatt
 |      OpSame prim                     { $$ = b.patternEquals($2); }
 |      OpNSame prim                    { b.reserved($1,"not-same pattern"); }
 |      compOp prim                     { b.reserved($1,
                                                     "comparison pattern"); }
 ;

quasiPatt:
        namer
 |      quasiParser quasiPattern        { $$ = b.quasiPattern($1, $2); }
 /* XXX Why is this a conflict?
 |      noun '(' paramList ')'          { b.reserved($2,"struct-pattern"); }
 XXX The IN keyword below is just too ugly!
 */
 |      IN prim '(' paramList ')'          { b.reserved($1,"struct-pattern"); }
 |      IN prim '.' verb '(' paramList ')' { b.reserved($1,"struct-pattern"); }
 |      IN prim '[' paramList ']'          { b.reserved($1,"struct-pattern"); }
 ;

quasiPattern:
        QuasiClose                              { $$ = b.list($1); }
 |      innerThings QuasiClose                  { $$ = b.with($1, $2); }
 ;

innerThings:
        QuasiOpen innerThing                    { $$ = b.list($1, $2); }
 |      innerThings QuasiOpen innerThing        { $$ = b.with(b.with($1, $2),
                                                              $3); }
 ;

innerThing:
        innerExpr
 |      innerPattern
 ;

innerPattern:
        AtIdent                                 { $$ = b.atNoun($1); }
 |      AtOpen br pattern br '}'                { $$ = $3; }
 ;


/**
 * Namers are patterns that bind at most one name.
 * The 'nounExpr' forms are the only defining lambda occurance of a
 * variable name.
 * <p>
 * Wherever a namer is needed, a "_" can be used to match anything
 * and suppress binding a name.
 */
namer:
        nounExpr ':' guard              { $$ = b.finalPattern($1, $3); }
 |      nounExpr                        { b.antiPocket($1,
                                                       "explicit-final-guard");
                                          $$ = b.finalPattern($1); }
 |      _                               { $$ = b.ignore(); }
 |      _ ':' guard                     { b.reserved($1,"anon guard"); }
 |      binder
 |      varNamer
 |      slotNamer
 ;

binder:
        BIND noun ':' guard             { $$ = b.bindDefiner($2, $4); }
 |      BIND noun                       { b.antiPocket($1,
                                                       "explicit-final-guard");
                                          $$ = b.bindDefiner($2); }
 ;

varNamer:
        VAR nounExpr ':' guard          { $$ = b.varPattern($2, $4); }
 |      VAR nounExpr                    { b.antiPocket($1,
                                                       "explicit-var-guard");
                                          $$ = b.varPattern($2); }
 ;

slotNamer:
        '&' nounExpr ':' guard          { $$ = b.slotPattern($2, $4); }
 |      '&' nounExpr                    { b.antiPocket($1,
                                                       "explicit-slot-guard");
                                          $$ = b.slotPattern($2); }
 ;


/**
 * The name pattern, or literal name, for an object definition
 * expression
 */
oName:
        nounExpr                        { $$ = b.finalPattern($1); }
 |      _                               { $$ = b.ignore(); }
 |      BIND noun                       { $$ = b.bindDefiner($2); }
 |      VAR nounExpr                    { $$ = b.varPattern($2); }
 |      litString
 ;


/**
********************************************
**               Pattern Lists
********************************************
*/

//XXX Express the paramList grammar in a more regular form.
paramList:
        emptyBr
 |      br params br                    { $$ = $2; }
 ;

params:
        patterns
 |      patterns ',' restParams         { b.pocket($2,"map-tail");
                                         $$ = b.with($1,
                                                     b.mapPattern($3,
                                                                  b.ignore()));
                                        }
 |                   restParams         { b.pocket(b.NO_POSER,"map-tail");
                                         $$ = b.list(b.mapPattern($1,
                                                                  b.ignore()));
                                        }
 ;

restParams:
        mapPatterns
 |      pattern OpAss order                { b.reserved($2,
                                             "default positional param"); }
 |      pattern OpAss order ',' restParams { b.reserved($2,
                                             "default positional param"); }
 ;

patternList:
        emptyBr
 |      br patterns br                  { $$ = $2; }
 ;

patterns:
        pattern                         { $$ = b.list($1); }
 |      patterns ',' pattern            { $$ = b.with($1, $3); }
 ;

mapPatternList:
        br mapPatterns br               { $$ = $2; }
 ;

mapPatterns:
        mapPattern                      { $$ = b.list($1); }
 |      mapPatterns ',' mapPattern      { $$ = b.with($1, $3); }
 ;

mapPattern:
        key MapsTo pattern              { $$ = b.assoc($1, $3); }
 |      key MapsTo pattern OpAss order  { b.pocket($4,"pattern-default");
                                          $$ = b.assoc($1, b.assoc($5,$3)); }
 |          MapsTo namer                { b.pocket($1,"importer");
                                          $$ = b.importer($2); }
 |          MapsTo namer OpAss order    { b.pocket($3,"pattern-default");
                                          b.pocket($1,"importer");
                                          $$ = b.importer(b.assoc($4,$2)); }
 ;

key:
        parenExpr
 |      literal
 ;


/*
********************************************
**               Non-Expressions
********************************************
*/

/**
 * An optional doc-comment.
 */
doco:
        /*empty*/                       { $$ = ""; }
 |      DocComment
 ;

/**
 * An oName together with the initial "def"ish keyword
 */
defName:
        DEF oName                       { $$ = $2; }
 |      BIND noun                       { $$ = b.bindDefiner($2); }
 |      VAR nounExpr                    { $$ = b.varPattern($2); }
 ;

/**
 *
 */
oDeclTail:
        /*empty*/                       { $$ = ODECL; }
 |      extends                         { $$ = ODECL.withExtends($1); }
 |              impls                   { $$ = ODECL.withAuditors($1);}
 |      extends impls                   { $$ = ODECL.withExtends($1)
                                                            .withAuditors($2);}
 /* thanks to Dean for suggesting the following error-catch clause: */
 |      impls extends   { yyerror("'extends' must come before 'implements'"); }
 ;

/**
 *
 */
iDeclTail:
        /*empty*/                       { $$ = ODECL; }
 |      iExtends                        { $$ = ODECL.withExtends($1); }
 |               impls                  { $$ = ODECL.withAuditors($1);}
 |      iExtends impls                  { $$ = ODECL.withExtends($1)
                                                            .withAuditors($2);}
 /* thanks to Dean for suggesting the following error-catch clause: */
 |      impls iExtends  { yyerror("'extends' must come before 'implements'"); }
 ;


/**
 * The value will be magically called 'super', and will be delegated
 * to for any messages that don't match.
 * <p>
 * At the time of this writing, the grammar would sustain 'assign'
 * instead of 'order' here, but 'order' is the most that should be
 * accepted without parens.
 */
extends:
        EXTENDS order                   { $$ = b.list($2); }
 ;

/**
 * An interface may extend any number of other interfaces.
 */
iExtends:
        EXTENDS order                   { $$ = b.list($2); }
 |      iExtends ',' order              { $$ = b.with($1, $3); }
 ;

/**
 * The list of auditors.
 * <p>
 * At the time of this writing, the grammar would sustain 'assign'
 * instead of 'order' here, but 'order' is the most that should be
 * accepted without parens.
 */
impls:
        IMPLEMENTS order                { $$ = b.list($2); }
 |      impls ',' order                 { $$ = b.with($1, $3); }
 ;


litString:
        LiteralString
 |      LiteralTwine
 |      litString LiteralString         { b.reserved($2,"literal concat"); }
 |      litString LiteralTwine          { b.reserved($2,"literal concat"); }
 ;

/**
 * As a method, this will match the corresponding message and evaluate
 * its body in the current lexical scope extended by binding the
 * methHead's patterns to the message's args.
 */
method:
        doco TO methHead body                { /* binds __return */
                                               $$ = b.to($1, $3, $4); }
 |      doco METHOD methHead body            { /* doesn't bind __return */
                                               $$ = b.method($1, $3, $4); }
 |      doco ON methHead body                { b.reserved($2,"on event"); }

 |      doco DEF field OpAss assign          { b.reserved($2,"final field"); }
 |      doco VAR field OpAss assign          { b.reserved($2,"var field"); }

 |      doco TO field body                   { b.reserved($2,"field getter"); }
 |      doco TO field OpAss pattern body     { b.reserved($4,"field setter"); }
 |      doco TO '&' field body               { b.reserved($3,"field's slot"); }

 |      doco META parenExpr body             { b.reserved($2,"sealed meta1"); }
 |      doco META parenExpr MapsTo parenExpr { b.reserved($2,"sealed meta2"); }
 ;

/**
 *
 */
field:
        prop
 |      prop ':' guard
 ;

/**
 * Appears in method definition
 */
methHead:
             '(' paramList ')' resultGuard { $$ = b.methHead($1,"run",$2,$4); }
 |      verb '(' paramList ')' resultGuard { $$ = b.methHead($1,      $3,$5); }
 ;


/**
 * Appears in "function" definition
 */
funcHead:
        '(' paramList ')' resultGuard   { $$ = b.methHead($1,"run", $2, $4);}

 |      TO verb '(' paramList ')' resultGuard { b.pocket($1,
                                                         "one-method-object");
                                                $$ = b.methHead($2, $4, $6); }
 |      '.' verb '(' paramList ')' resultGuard {b.pocket($1,
                                                         "one-method-object");
                                                $$ = b.methHead($2, $4, $6); }
 ;


/**
 * Within a script, this will generically match any message
 * not matched by an earlier method.  The pattern will be bound to a
 * 2-Tuple whose 0-element will be the verb string, and the 1-element
 * will be a Tuple of the argument values.
 */
matcher:
        MATCH pattern           body    { $$ = b.matcher($2, $3); }
 ;

/**
 * Expands to a match clause:
 *
 *      delegate { expr } -> match [v,a] { E call(expr, v,a) }
 */
delegator:
        DELEGATE body                   { b.pocket($1,"delegate-clause");
                                          $$ = b.delegatex($2); }
 ;

/**
 *
 */
guard:
        order
 |      compOp order                    { b.reserved($1,"*-variant guard"); }
 ;

compOp:
        '<' | OpLeq | OpABA | OpGeq | '>'
 ;

/**
 * Optional guard. If empty, is considered equivalent to the normal meaning
 * of ":any".
 */
resultGuard:
        ':' guard                       { $$ = $2; }
 |      /*empty*/               { $$ = b.defaultOptResultGuard(yylval); }
 |      ':' guard THROWS throws         { b.reserved($2,"throws"); }
 ;
throws:
        guard                           { $$ = b.list($1); }
 |      throws ',' guard                { $$ = b.with($1,$3); }
 // XXX make comma tolerant
 ;

whenArgs:
        '(' args ')'                    { $$ = $2; }
 ;

/**
 *
 */
whenHead:
        whenArgs OpWhen oName '(' params ')' resultGuard
                        { /* binds __return */
                          $$ = b.list($1, ODECL.withOName($3),
                                      $4, $5, $7); }
 |      whenArgs OpWhen       '(' params ')' resultGuard
                        { /* binds __return */
                          b.reserved($2,"no doneClosureName");
                          $$ = b.list($1, ODECL.withOName(b.ignore()),
                                      $3, $4, $6); }
 |      whenArgs OpWhen
                        { /* shouldn't bind __return, but currently does */
                          b.reserved($2,"no doneClosureHead");
                          $$ = b.list($1, ODECL.withOName(b.ignore()),
                                      $2, b.list(b.ignore()), null); }
 ;

br:
        /*empty*/
 |      EOLs
 ;

EOLs:
        EOL
 |      EOLs EOL
 ;


/**
 *
 */
emptyList:
        /*empty*/                       { $$ = b.list(); }
 ;

emptyBr:
        br                              { $$ = b.list(); }
 ;


/**
 * A message selector
 */
verb:
        ident
 |      litString                       { b.pocket($1,"verb-string");
                                          $$ = $1; }
 ;

/**
 * A vcurry is supposed to be a verb name on which we're currying
 */
vcurry:
        ident                           { b.pocket($1,"verb-curry");
                                          $$ = $1; }
 |      litString                       { b.pocket($1,"verb-curry");
                                          b.pocket($1,"verb-string");
                                          $$ = $1; }
 ;

/**
 * A property name.  The value of property name "foo" is "getFoo".
 * The assignment transformation will turn getFoo/0 into setFoo/1.
 *
 * XXX Should probably expand this to include " '&' ident" | " '&' litString".
 */
prop:
        ident                           { b.pocket($1,"dot-props");
                                          $$ = $1; }
 |      litString                       { b.pocket($1,"dot-props");
                                          $$ = $1; }
 ;

/**
 * A variable name
 */
noun:
        ident                           { $$ = b.varName($1); }
 |      '%' LiteralString               { b.reserved($1,"non-ident var"); }
 |      OpMod LiteralString             { b.reserved($1,"non-ident var"); }
 |      OpScope LiteralString           { b.reserved($1,"non-ident var"); }
 ;

/**
 * A non-reserved ID (as a String)
 */
ident:
        ID
 |      reserved        { b.reserved($1,"keyword \"" +
                                     ((Astro)$1).getTag().getTagName() +
                                     "\""); }
 ;


/**
 * x op= y  ->  x := x op y
 *
 * Except that side effects with 'x' must only happen once, and before
 * y is evaluated.  (The current Parser is known not to do this
 * correctly.)
 *
 * XXX We should probably phase out '%' and '%='.
 */
assignop:
        OpAssAdd                        { $$ = b.ident($1, "add"); }
 |      OpAssAnd                        { $$ = b.ident($1, "and"); }
 |      OpAssAprxDiv                    { $$ = b.ident($1, "approxDivide"); }
 |      OpAssFlrDiv                     { $$ = b.ident($1, "floorDivide"); }
 |      OpAssAsl                        { $$ = b.ident($1, "shiftLeft"); }
 |      OpAssAsr                        { $$ = b.ident($1, "shiftRight"); }
 |      OpAssRemdr                      { $$ = b.ident($1, "remainder"); }
 |      OpAssMod                        { $$ = b.ident($1, "mod"); }
 |      OpAssMul                        { $$ = b.ident($1, "multiply"); }
 |      OpAssOr                         { $$ = b.ident($1, "or"); }
 |      OpAssPow                        { $$ = b.ident($1, "pow"); }
 |      OpAssSub                        { $$ = b.ident($1, "subtract"); }
 |      OpAssXor                        { $$ = b.ident($1, "xor"); }

 |      VerbAssign
 ;


/**
 * Note that 'verb' is handled separately, in order to require parens
 * around the argument list.
 *
 * XXX We should probably phase out '%' and '%='.
 */
assignableop:
        '+'                             { $$ = b.ident($1, "add"); }
 |      '&'                             { $$ = b.ident($1, "and"); }
 |      '/'                             { $$ = b.ident($1, "approxDivide"); }
 |      OpFlrDiv                        { $$ = b.ident($1, "floorDivide"); }
 |      OpAsl                           { $$ = b.ident($1, "shiftLeft"); }
 |      OpAsr                           { $$ = b.ident($1, "shiftRight"); }
 |      '%'                             { $$ = b.ident($1, "remainder"); }
 |      OpMod                           { $$ = b.ident($1, "mod"); }
 |      '*'                             { $$ = b.ident($1, "multiply"); }
 |      '|'                             { $$ = b.ident($1, "or"); }
 |      OpPow                           { $$ = b.ident($1, "pow"); }
 |      '-'                             { $$ = b.ident($1, "subtract"); }
 |      '^'                             { $$ = b.ident($1, "xor"); }
 ;


/**
 * body represents the potential to evaluate eExpr in its own
 * scope (which is always a child of the current lexical scope)
 */
body:
        '{' br '}'                      { $$ = b.getNULL(); }
 |      '{' eExpr '}'                   { $$ = $2; }
 ;


/**
 * E's answer to the Haskell / Python list comprehension syntax.
 */
accumExpr:
        ACCUM postfix accumulator               { b.pocket($1,"accumulator");
                                                  $$ = b.accumulate($2,$3); }
 ;

accumulator:
        FOR iterPattern IN assign accumBody     { $$ = b.accumFor($2,$4,$5); }
 |      IF parenExpr              accumBody     { $$ = b.accumIf($2,$3); }
 |      WHILE parenExpr           accumBody     { $$ = b.accumWhile($2,$3); }
 ;

accumBody:
        '{' br _ assignableop nAssign br '}'    { $$ = b.accumBody($4,$5); }
 |      '{' br _ '.' verb parenArgs br '}'      { $$ = b.accumBody($5,$6); }
 |      '{' br accumulator br '}'               { $$ = $3; }
 ;


caseList:
        '{' br matchList '}'                    { $$ = $3; }
 ;

vTable:
        '{' br methodList vMatchList '}'        { $$ = b.vTable($3, $4); }
 |      matcher                                 { b.pocket(b.NO_POSER,
                                                           "plumbing");
                                                  $$ = b.vTable(null,
                                                                b.list($1)); }
 |      delegator                               { b.pocket(b.NO_POSER,
                                                           "plumbing");
                                                  $$ = b.vTable(null,
                                                                b.list($1)); }
 ;

/**
 *
 */
methodList:
        emptyList
 |      methodList method br                    { $$ = b.with($1, $2); }
 ;

vMatchList:
        matchList
 |      matchList delegator br                  { $$ = b.with($1, $2); }
 ;

matchList:
        emptyList
 |      matchList matcher br                    { $$ = b.with($1, $2); }
 ;


/**
 * Middle part of a 'try' expression
 */
catchList:
        emptyList
 |      catches
 ;

/**
 * Middle part of a 'when' expression -- an least one catch clause is
 * required
 */
catches:
        catchList catcher                       { $$ = b.with($1, $2); }
 ;

optHandler:
        /*empty*/                               { $$ = null; }
 |      catcher                                 { b.pocket(b.NO_POSER,
                                                           "escape-handler");
                                                  $$ = $1; }
 ;

catcher:
        CATCH pattern body                      { $$ = b.matcher($2, $3); }
 ;

/**
 * Last part of a 'try' expression
 */
finallyClause:
        /*empty*/                               { $$ = null; }
 |      FINALLY body                            { $$ = $2; }
 ;



/**
 * Further sugar for defining types of functions.
 */
oFuncType:
        INTERFACE oName typeParams funcType
                                        { $$ = b.oType("", $2, b.list($4)); }
 ;

typeParams:
        /*empty*/
 |      '[' br pTypes br ']'            { b.reserved($1,"type params"); }
 |      '[' br ']'            { yyerror("Must have at least one type param"); }
 ;

/**
 *
 */
guards:
        /*empty*/                               { $$ = null; }
 |      GUARDS pattern                          { $$ = $2; }
 ;

mTypeList:
        emptyList
 |      DELEGATE br                             { b.pocket($1,
                                                           "delegate-clause");
                                                  $$ = $1; }
 |      mTypes br
 |      mTypes EOLs DELEGATE br                 { $$ = b.with($1,$3); }
 ;

mTypes:
        mType                                   { $$ = b.list($1); }
 |      mTypes EOLs mType                       { $$ = b.with($1,$3); }
 ;

/**
 * Message Type
 */
mType:
        mTypeHead
 |      mTypeHead body                  { b.reserved(b.NO_POSER,"causality"); }
 ;

mTypeHead:
        doco TO verb '(' pTypeList ')' optType
                                        { $$ = b.mType($1, $3, $5, $7); }
 |      doco TO      '(' pTypeList ')' optType
                                        { $$ = b.mType($1, "run", $4, $6);}
 ;

/**
 * Function Type
 */
funcType:
        funcTypeHead
 |      funcTypeHead body               { b.reserved(b.NO_POSER,"causality"); }
 ;

funcTypeHead:
                '(' pTypeList ')' optType { $$ = b.mType("", "run", $2, $4); }
 |      TO verb '(' pTypeList ')' optType { b.pocket($1,"one-method-object");
                                            $$ = b.mType("", $2,    $4, $6); }
 |      '.' verb '(' pTypeList ')' optType {b.pocket($1,"one-method-object");
                                            $$ = b.mType("", $2,    $4, $6); }
 ;

pTypeList:
        br emptyList                            { $$ = $2; }
 |      br pTypes br                            { $$ = $2; }
 ;


pTypes:
        pType                                   { $$ = b.list($1); }
 |      pTypes ',' pType                        { $$ = b.with($1,$3); }
 ;

/**
 * Parameter type
 */
pType:
        noun optType                            { $$ = b.pType($1,$2); }
 |      _ optType                               { $$ = b.pType(null,$2); }
 ;


/**
 * XXX Needs to be extended to allow parameterized type expressions
 */
optType:
        /*empty*/                               { $$ = null; }
 |      ':' guard                               { $$ = $2; }
 ;

/**
 *
 */
metaoid:
        META
 |      PRAGMA
 ;


/**
 * Reserved Keywords
 */
reserved:
        ABSTRACT | AN | AS | ASSERT | ATTRIBUTE
 |      BE | BEGIN | BEHALF | BELIEF | BELIEVE | BELIEVES
 |      CASE | CLASS | CONST | CONSTRUCTOR
 |      DECLARE | DEFAULT | DEFINE | DEFMACRO
 |      DELICATE | DEPRECATED | DISPATCH | DO
 |      ENCAPSULATE | ENCAPSULATED | ENCAPSULATES
 |      END | ENSURE | ENUM | EVENTUAL | EVENTUALLY
 |      EXPORT | FACET | FORALL | FUNCTION | GIVEN | HIDDEN
 |      HIDES | INLINE | IS
 |      KNOW | KNOWS | LAMBDA | LET | METHODS
 |      NAMESPACE | NATIVE
 |      OBEYS | OCTET | ONEWAY | OPERATOR
 |      PACKAGE | PRIVATE | PROTECTED | PUBLIC
 |      RAISES | RELIANCE | RELIANT | RELIES | RELY | REVEAL
 |      SAKE | SIGNED | STATIC | STRUCT
 |      SUCHTHAT | SUPPORTS | SUSPECT | SUSPECTS | SYNCHRONIZED
 |      THIS | TRANSIENT | TRUNCATABLE | TYPEDEF
 |      UNSIGNED | UNUM | USES | USING | UTF8 | UTF16
 |      VIRTUAL | VOLATILE | WSTRING
 ;


%%


/**
 *
 */
static public final StaticMaker EParserMaker =
    StaticMaker.make(EParser.class);

/**
 * caches previous simple parses (as is used for quasi-parsing)
 */
static private final IdentityCacheTable OurCache =
    new IdentityCacheTable(ENode.class, 100);

/**
 *
 */
static private final ConstMap DefaultProps =
  ConstMap.fromProperties(System.getProperties());



/** contains all the tokens after yylval */
private final LexerFace myLexer;

/**
 * Do we escape after parsing only one expression, or do we parse the
 * entire input?
 */
private final boolean myOnlyOneExprFlag;

/**
 * Where the result is stored by the top-level productions
 */
private ENode myOptResult;

/** receives parsing events */
private final EBuilder b;


/**
 *
 */
static public EParser make(LexerFace lexer, TextWriter warns) {
    return make(null, lexer, warns, false, false);
}

/**
 *
 */
static public EParser make(ConstMap props, LexerFace lexer, TextWriter warns) {
    return make(props, lexer, warns, false, false);
}

/**
 *
 */
static public EParser make(ConstMap optProps,
                           LexerFace lexer,
                           TextWriter warns,
                           boolean debugFlag,
                           boolean onlyOneExprFlag) {
    if (null == optProps) {
        optProps = DefaultProps;
    }
    return new EParser(new ENodeBuilder(optProps, lexer, warns),
                       lexer,
                       debugFlag,
                       onlyOneExprFlag);
}

/**
 *
 */
public EParser(ENodeBuilder builder,
               LexerFace lexer,
               boolean debugFlag,
               boolean onlyOneExprFlag) {
    b = builder;
    initTables();
    myLexer = lexer;
    yydebug = debugFlag;
    myOnlyOneExprFlag = onlyOneExprFlag;
    myOptResult = null;
}

/**
 * For use as from E as a quasi-literal parser.
 * <p>
 * Transparently caches the result
 *
 * @param sourceCode The source code itself, not the location of
 * the source code
 */
static public ENode valueMaker(Twine sourceCode) {
    ENode result = (ENode)OurCache.fetch(sourceCode, ValueThunk.NULL_THUNK);
    if (null == result) {
        result = run(sourceCode, true);
        OurCache.put(sourceCode, result);
    }
    return result;
}

/**
 * For use from E as a quasi-pattern parser.
 * <p>
 * Just delegates to valueMaker/1.
 *
 * @param sourceCode The source code itself, not the location of
 * the source code
 */
static public ENode matchMaker(Twine sourceCode) {
    return valueMaker(sourceCode);
}


/**
 * For simple string -> expression parsing, especially for use from E
 *
 * @param sourceCode The source code itself, not the location of
 * the source code
 */
static public ENode run(Twine sourceCode) {
    return run(sourceCode, false);
}

/**
 *
 */
static public ENode run(Twine sourceCode, boolean quasiFlag) {
    TextWriter warns = new TextWriter(PrintStreamWriter.stderr());
    return run(sourceCode, quasiFlag, null, warns);
}

/**
 * No longer does the caching.
 */
static public ENode run(Twine sourceCode,
                        boolean quasiFlag,
                        ConstMap optProps,
                        TextWriter warns) {
    try {
        if (null == optProps) {
            optProps = DefaultProps;
        }
        LexerFace lexer = ELexer.make(sourceCode,
                                      quasiFlag,
                                      ConstMap.testProp(optProps,
                                                        "e.enable.notabs"));
        EParser parser = EParser.make(optProps,
                                      lexer,
                                      warns,
                                      false,
                                      false);
        return parser.parse();

    } catch (IOException iox) {
        throw new NestedException(iox, "# parsing a string?!");
    }
}

/**
 *
 */
public ENode optParse() {
    if (yyparse() != 0) {
        yyerror("couldn't parse expression");
    }
    return myOptResult;
}

/**
 * If the input is empty, returns the null expression e`null`, rather
 * than null.
 */
public ENode parse() {
    ENode result = optParse();
    if (result == null) {
        return b.getNULL();
    } else {
        return result;
    }
}

/**
 * Converts EOTLUs to either EOLs or EOFTOKs according to myOnlyOneExprFlag
 * <p>
 * Note that yacc uses tag-codes, while Antlr uses type-codes.
 */
private short yylex() {
    if (myLexer.isEndOfFile()) {
        yylval = null;
        return LexerFace.EOFTOK;
    }
    Astro token = null;
    try {
        token = myLexer.nextToken();
    } catch (IOException ex) {
        yyerror("io: " + ex);
    }
    yylval = token;
    short code = token.getOptTagCode();
    if (EOTLU == code) {
        if (myOnlyOneExprFlag) {
            return LexerFace.EOFTOK;
        } else {
            return EOL;
        }
    } else {
        return code;
    }
}

/**
 *
 */
private void yyerror(String s) throws SyntaxException {
    if ("syntax error".equals(s)) {
        if (null == yylval) {
            myLexer.needMore("Unexpected EOF");
            return; //give the compiler better info
        }
        short tagCode = ((Astro)yylval).getOptTagCode();
        if (LexerFace.EOFTOK == tagCode) {
            myLexer.needMore("Unexpected EOF");
            return; //give the compiler better info
        }
    }
    myLexer.syntaxError(s);
}

/**
 *
 */
public void setSource(Twine newSource) {
    myLexer.setSource(newSource);
}

/**
 *
 */
public boolean isEndOfFile() {
    return myLexer.isEndOfFile();
}

/**
 *
 */
static NounExpr noun(Object name) {
    return ENodeBuilder.noun(name);
}

/**
 *
 */
static private boolean isTokenKind(Object tok, int[] members) {
    if (! (tok instanceof Astro)) {
        return false;
    }
    short tagCode = ((Astro)tok).getOptTagCode();
    for (int i = 0; i < members.length; i++) {
        if (tagCode == members[i]) {
            return true;
        }
    }
    return false;
}

static private final int[] LiteralTypes = {
    LiteralInteger,
    LiteralFloat64,
    LiteralChar,
    LiteralString,
    LiteralTwine
};

/**
 *
 */
static boolean isLiteralToken(Object tok) {
    return isTokenKind(tok, LiteralTypes);
}

static private final int[] QuasiTypes = {
    QuasiOpen,
    QuasiClose
};

/**
 *
 */
static boolean isQuasiPart(Object tok) {
    return isTokenKind(tok, QuasiTypes);
}



/*********************************/


/**
 *
 */
static private final String[] TheTokens = new String[yyname.length];

/**
 * For all the names below, if the name == name.toLowerCase(), then
 * the name must be a keyword.  Else it must not be a keyword.  The
 * names themselves must be legal Term tags.
 */
static {
    System.arraycopy(yyname, 0, TheTokens, 0, yyname.length);

    TheTokens[LexerFace.EOFTOK] = "EOFTOK";
    /* The magical end-of-line token, not considered whitespace */
    TheTokens[EOL]              = "EOL";
    TheTokens[EOTLU]            = "EOTLU";

    TheTokens[LiteralInteger]   = ".int.";
    TheTokens[LiteralFloat64]   = ".float64.";
    TheTokens[LiteralChar]      = ".char.";
    TheTokens[LiteralString]    = ".String.";
    TheTokens[LiteralTwine]     = ".Twine.";

    TheTokens[ID]               = "ID";
    TheTokens[VerbAssign]       = "VerbAssign";
    TheTokens[QuasiOpen]        = "QuasiOpen";
    TheTokens[QuasiClose]       = "QuasiClose";
    TheTokens[DollarIdent]      = "DollarIdent";
    TheTokens[AtIdent]          = "AtIdent";
    TheTokens[DollarOpen]       = "DollarOpen";
    TheTokens[AtOpen]           = "AtOpen";
    TheTokens[URI]              = "URI";
    TheTokens[URIStart]         = "URIStart";
    TheTokens[DocComment]       = "DocComment";
    TheTokens[BodyStartWord]    = "BodyStartWord";
    TheTokens[BodyNextWord]     = "BodyNextWord";
    TheTokens[VTableStartWord]  = "VTableStartWord";
    TheTokens[VTableNextWord]   = "VTableNextWord";

    /* Keywords */
    TheTokens[BIND]             = "bind";
    TheTokens[BREAK]            = "break";
    TheTokens[CATCH]            = "catch";
    TheTokens[CONTINUE]         = "continue";
    TheTokens[DEF]              = "def";
    TheTokens[ELSE]             = "else";
    TheTokens[ESCAPE]           = "escape";
    TheTokens[EXTENDS]          = "extends";
    TheTokens[FINALLY]          = "finally";
    TheTokens[FOR]              = "for";
    TheTokens[GUARDS]           = "guards";
    TheTokens[IF]               = "if";
    TheTokens[IMPLEMENTS]       = "implements";
    TheTokens[IN]               = "in";
    TheTokens[INTERFACE]        = "interface";
    TheTokens[MATCH]            = "match";
    TheTokens[META]             = "meta";
    TheTokens[METHOD]           = "method";
    TheTokens[PRAGMA]           = "pragma";
    TheTokens[RETURN]           = "return";
    TheTokens[SWITCH]           = "switch";
    TheTokens[THUNK]            = "thunk";
    TheTokens[TO]               = "to";
    TheTokens[TRY]              = "try";
    TheTokens[VAR]              = "var";
    TheTokens[WHEN]             = "when";
    TheTokens[WHILE]            = "while";
    TheTokens[_]                = "_";

    /* pseudo-reserved keywords */
    TheTokens[ACCUM]            = "accum";
    TheTokens[DELEGATE]         = "delegate";
    TheTokens[MODULE]           = "module";
    TheTokens[ON]               = "on";
    TheTokens[SELECT]           = "select";
    TheTokens[THROWS]           = "throws";

    /* reserved keywords */
    TheTokens[ABSTRACT]         = "abstract";
    TheTokens[AN]               = "an";
    TheTokens[AS]               = "as";
    TheTokens[ASSERT]           = "assert";
    TheTokens[ATTRIBUTE]        = "attribute";
    TheTokens[BE]               = "be";
    TheTokens[BEGIN]            = "begin";
    TheTokens[BEHALF]           = "behalf";
    TheTokens[BELIEF]           = "belief";
    TheTokens[BELIEVE]          = "believe";
    TheTokens[BELIEVES]         = "believes";
    TheTokens[CASE]             = "case";
    TheTokens[CLASS]            = "class";
    TheTokens[CONST]            = "const";
    TheTokens[CONSTRUCTOR]      = "constructor";
    TheTokens[DECLARE]          = "declare";
    TheTokens[DEFAULT]          = "default";
    TheTokens[DEFINE]           = "define";
    TheTokens[DEFMACRO]         = "defmacro";
    TheTokens[DELICATE]         = "delicate";
    TheTokens[DEPRECATED]       = "deprecated";
    TheTokens[DISPATCH]         = "dispatch";
    TheTokens[DO]               = "do";
    TheTokens[ENCAPSULATE]      = "encapsulate";
    TheTokens[ENCAPSULATED]     = "encapsulated";
    TheTokens[ENCAPSULATES]     = "encapsulates";
    TheTokens[END]              = "end";
    TheTokens[ENSURE]           = "ensure";
    TheTokens[ENUM]             = "enum";
    TheTokens[EVENTUAL]         = "eventual";
    TheTokens[EVENTUALLY]       = "eventually";
    TheTokens[EXPORT]           = "export";
    TheTokens[FACET]            = "facet";
    TheTokens[FORALL]           = "forall";
    TheTokens[FUNCTION]         = "function";
    TheTokens[GIVEN]            = "given";
    TheTokens[HIDDEN]           = "hidden";
    TheTokens[HIDES]            = "hides";
    TheTokens[INLINE]           = "inline";
    TheTokens[IS]               = "is";
    TheTokens[KNOW]             = "know";
    TheTokens[KNOWS]            = "knows";
    TheTokens[LAMBDA]           = "lambda";
    TheTokens[LET]              = "let";
    TheTokens[METHODS]          = "methods";
    TheTokens[NAMESPACE]        = "namespace";
    TheTokens[NATIVE]           = "native";
    TheTokens[OBEYS]            = "obeys";
    TheTokens[OCTET]            = "octet";
    TheTokens[ONEWAY]           = "oneway";
    TheTokens[OPERATOR]         = "operator";
    TheTokens[PACKAGE]          = "package";
    TheTokens[PRIVATE]          = "private";
    TheTokens[PROTECTED]        = "protected";
    TheTokens[PUBLIC]           = "public";
    TheTokens[RAISES]           = "raises";
    TheTokens[RELIANCE]         = "reliance";
    TheTokens[RELIANT]          = "reliant";
    TheTokens[RELIES]           = "relies";
    TheTokens[RELY]             = "rely";
    TheTokens[REVEAL]           = "reveal";
    TheTokens[SAKE]             = "sake";
    TheTokens[SIGNED]           = "signed";
    TheTokens[STATIC]           = "static";
    TheTokens[STRUCT]           = "struct";
    TheTokens[SUCHTHAT]         = "suchthat";
    TheTokens[SUPPORTS]         = "supports";
    TheTokens[SUSPECT]          = "suspect";
    TheTokens[SUSPECTS]         = "suspects";
    TheTokens[SYNCHRONIZED]     = "synchronized";
    TheTokens[THIS]             = "this";
    TheTokens[TRANSIENT]        = "transient";
    TheTokens[TRUNCATABLE]      = "truncatable";
    TheTokens[TYPEDEF]          = "typedef";
    TheTokens[UNSIGNED]         = "unsigned";
    TheTokens[UNUM]             = "unum";
    TheTokens[USES]             = "uses";
    TheTokens[USING]            = "using";
    TheTokens[UTF8]             = "utf8";
    TheTokens[UTF16]            = "utf16";
    TheTokens[VIRTUAL]          = "virtual";
    TheTokens[VOLATILE]         = "volatile";
    TheTokens[WSTRING]          = "wstring";

    /* Single-Character Tokens */
    TheTokens[';']              = "SemiColon";
    TheTokens['&']              = "Ampersand";
    TheTokens['|']              = "VerticalBar";
    TheTokens['^']              = "Caret";
    TheTokens['+']              = "Plus";
    TheTokens['-']              = "Minus";
    TheTokens['*']              = "Star";
    TheTokens['/']              = "Slash";
    TheTokens['%']              = "Percent";
    TheTokens['!']              = "Bang";
    TheTokens['~']              = "Tilde";
    TheTokens['$']              = "Dollar";
    TheTokens['@']              = "At";
    TheTokens[',']              = "Comma";
    TheTokens['?']              = "Question";
    TheTokens[':']              = "Colon";
    TheTokens['.']              = "Dot";

    TheTokens['(']              = "OpenParen";
    TheTokens[')']              = "CloseParen";
    TheTokens['[']              = "OpenBracket";
    TheTokens[']']              = "CloseBracket";
    TheTokens['{']              = "OpenBrace";
    TheTokens['}']              = "CloseBrace";
    TheTokens['<']              = "OpenAngle";
    TheTokens['>']              = "CloseAngle";


    /* Multi-Character Operators */
    TheTokens[OpLAnd]           = "OpLAnd";
    TheTokens[OpLOr]            = "OpLOr";
    TheTokens[OpSame]           = "OpSame";
    TheTokens[OpNSame]          = "OpNSame";
    TheTokens[OpButNot]         = "OpButNot";
    TheTokens[OpLeq]            = "OpLeq";
    TheTokens[OpABA]            = "OpABA";
    TheTokens[OpGeq]            = "OpGeq";
    TheTokens[OpThru]           = "OpThru";
    TheTokens[OpTill]           = "OpTill";
    TheTokens[OpAsl]            = "OpAsl";
    TheTokens[OpAsr]            = "OpAsr";
    TheTokens[OpFlrDiv]         = "OpFlrDiv";
    TheTokens[OpMod]            = "OpMod";
    TheTokens[OpPow]            = "OpPow";

    TheTokens[OpAss]            = "OpAss";
    TheTokens[OpAssAdd]         = "OpAssAdd";
    TheTokens[OpAssAnd]         = "OpAssAnd";
    TheTokens[OpAssAprxDiv]     = "OpAssAprxDiv";
    TheTokens[OpAssFlrDiv]      = "OpAssFlrDiv";
    TheTokens[OpAssAsl]         = "OpAssAsl";
    TheTokens[OpAssAsr]         = "OpAssAsr";
    TheTokens[OpAssRemdr]       = "OpAssRemdr";
    TheTokens[OpAssMod]         = "OpAssMod";
    TheTokens[OpAssMul]         = "OpAssMul";
    TheTokens[OpAssOr]          = "OpAssOr";
    TheTokens[OpAssPow]         = "OpAssPow";
    TheTokens[OpAssSub]         = "OpAssSub";
    TheTokens[OpAssXor]         = "OpAssXor";

    /* Other funky tokens */
    TheTokens[Send]             = "Send";
    TheTokens[OpWhen]           = "OpWhen";
    TheTokens[MapsTo]           = "MapsTo";
    TheTokens[MatchBind]        = "MatchBind";
    TheTokens[MisMatch]         = "MisMatch";
    TheTokens[OpScope]          = "OpScope";

    /* Non-token Kernel-E Term-tree tag names (ie, functor names) */

    TheTokens[AssignExpr]       = "AssignExpr";
    TheTokens[CallExpr]         = "CallExpr";
    TheTokens[DefineExpr]       = "DefineExpr";
    TheTokens[EscapeExpr]       = "EscapeExpr";
    TheTokens[HideExpr]         = "HideExpr";
    TheTokens[IfExpr]           = "IfExpr";
    TheTokens[LiteralExpr]      = "LiteralExpr";
    TheTokens[MatchBindExpr]    = "MatchBindExpr";
    TheTokens[NounExpr]         = "NounExpr";
    TheTokens[ObjectExpr]       = "ObjectExpr";
    TheTokens[QuasiLiteralExpr] = "QuasiLiteralExpr";
    TheTokens[QuasiPatternExpr] = "QuasiPatternExpr";
    TheTokens[MetaStateExpr]    = "MetaStateExpr";
    TheTokens[MetaContextExpr]  = "MetaContextExpr";
    TheTokens[SeqExpr]          = "SeqExpr";
    TheTokens[SlotExpr]         = "SlotExpr";
    TheTokens[MetaExpr]         = "MetaExpr";
    TheTokens[CatchExpr]        = "CatchExpr";
    TheTokens[FinallyExpr]      = "FinallyExpr";

    TheTokens[FinalPattern]     = "FinalPattern";
    TheTokens[VarPattern]       = "VarPattern";
    TheTokens[SlotPattern]      = "SlotPattern";
    TheTokens[ListPattern]      = "ListPattern";
    TheTokens[CdrPattern]       = "CdrPattern";
    TheTokens[IgnorePattern]    = "IgnorePattern";
    TheTokens[SuchThatPattern]  = "SuchThatPattern";
    TheTokens[QuasiLiteralPatt] = "QuasiLiteralPatt";
    TheTokens[QuasiPatternPatt] = "QuasiPatternPatt";

    TheTokens[EScript]          = "EScript";
    TheTokens[EMethod]          = "EMethod";
    TheTokens[EMatcher]         = "EMatcher";
}

/**
 *
 */
static public final AstroSchema DEFAULT_SCHEMA =
  new BaseSchema("E-Language", ConstList.fromArray(TheTokens));

/**
 *
 */
static private final int DEFAULT_CONTINUE_INDENT = 2;

/**
 * These are the tokens that may appear at the end of a line, in which
 * case the next line is a (to be indented) continuation of the
 * expression.
 * <p>
 * Note that &gt; isn't on the list because of its role in closing a
 * calculated URI expression.
 */
static private final int[][] TheContinuerOps = {
    { '!',          DEFAULT_CONTINUE_INDENT },
    { '%',          DEFAULT_CONTINUE_INDENT },
    { '&',          DEFAULT_CONTINUE_INDENT },
    { '*',          DEFAULT_CONTINUE_INDENT },
    { '+',          DEFAULT_CONTINUE_INDENT },
    { '-',          DEFAULT_CONTINUE_INDENT },
    { '/',          DEFAULT_CONTINUE_INDENT },
    { ':',          DEFAULT_CONTINUE_INDENT },
    { '<',          DEFAULT_CONTINUE_INDENT },
    { '?',          DEFAULT_CONTINUE_INDENT },
    { '^',          DEFAULT_CONTINUE_INDENT },
    { '|',          DEFAULT_CONTINUE_INDENT },
    { '~',          DEFAULT_CONTINUE_INDENT },
    { '.',          DEFAULT_CONTINUE_INDENT },

    { VerbAssign,   DEFAULT_CONTINUE_INDENT },    // ID"="
    { URIStart,     DEFAULT_CONTINUE_INDENT },    // "<" protocol ":"

    { EXTENDS,      DEFAULT_CONTINUE_INDENT },
    { IMPLEMENTS,   DEFAULT_CONTINUE_INDENT },
    { IN,           DEFAULT_CONTINUE_INDENT },
    { EXTENDS,      DEFAULT_CONTINUE_INDENT },

    { OpABA,        DEFAULT_CONTINUE_INDENT },    // <=>
    { OpAsl,        DEFAULT_CONTINUE_INDENT },    // <<
    { OpAsr,        DEFAULT_CONTINUE_INDENT },    // >>
    { OpAss,        DEFAULT_CONTINUE_INDENT },    // :=
    { OpAssAdd,     DEFAULT_CONTINUE_INDENT },    // +=
    { OpAssAnd,     DEFAULT_CONTINUE_INDENT },    // &=
    { OpAssAprxDiv, DEFAULT_CONTINUE_INDENT },    // /=
    { OpAssAsl,     DEFAULT_CONTINUE_INDENT },    // <<=
    { OpAssAsr,     DEFAULT_CONTINUE_INDENT },    // >>=
    { OpAssFlrDiv,  DEFAULT_CONTINUE_INDENT },    // //=
    { OpAssMod,     DEFAULT_CONTINUE_INDENT },    // %%=
    { OpAssMul,     DEFAULT_CONTINUE_INDENT },    // *=
    { OpAssOr,      DEFAULT_CONTINUE_INDENT },    // |=
    { OpAssPow,     DEFAULT_CONTINUE_INDENT },    // **=
    { OpAssRemdr,   DEFAULT_CONTINUE_INDENT },    // %=
    { OpAssSub,     DEFAULT_CONTINUE_INDENT },    // -=
    { OpAssXor,     DEFAULT_CONTINUE_INDENT },    // ^=
    { OpButNot,     DEFAULT_CONTINUE_INDENT },    // &!
    { OpFlrDiv,     DEFAULT_CONTINUE_INDENT },    // //
    { OpGeq,        DEFAULT_CONTINUE_INDENT },    // >=
    { OpLAnd,       DEFAULT_CONTINUE_INDENT },    // &&
    { OpLOr,        DEFAULT_CONTINUE_INDENT },    // ||
    { OpLeq,        DEFAULT_CONTINUE_INDENT },    // <=
    { OpMod,        DEFAULT_CONTINUE_INDENT },    // %%
    { OpNSame,      DEFAULT_CONTINUE_INDENT },    // !=
    { OpPow,        DEFAULT_CONTINUE_INDENT },    // **
    { OpSame,       DEFAULT_CONTINUE_INDENT },    // ==
    { OpThru,       DEFAULT_CONTINUE_INDENT },    // ..
    { OpTill,       DEFAULT_CONTINUE_INDENT },    // ..!

    { Send,         DEFAULT_CONTINUE_INDENT },    // <-
    { OpWhen,       DEFAULT_CONTINUE_INDENT },    // ->
    { MapsTo,       DEFAULT_CONTINUE_INDENT },    // =>
    { MatchBind,    DEFAULT_CONTINUE_INDENT },    // =~
    { MisMatch,     DEFAULT_CONTINUE_INDENT },    // !~
    { OpScope,      DEFAULT_CONTINUE_INDENT },    // ::

    { ',',          0 },
    { DocComment,   0 }                           // /**..*/
};

/**
 * TheContinuers[tagCode] says whether this is a continuation
 * operator, and if so, how much to indent by.
 * <p>
 * If this isn't a continuation operator, then -1.
 */
static private final int[] TheContinuers = new int[yyname.length];

static {
    for (int i = 0, len = TheContinuers.length; i < len; i++) {
        TheContinuers[i] = -1;
    }
    for (int i = 0; i < TheContinuerOps.length; i++) {
        TheContinuers[TheContinuerOps[i][0]] = TheContinuerOps[i][1];
    }
}

/**
 * If this token appears at the end of a line, does that make the next
 * line a (to be indented) continuation line?
 * <p>
 * -1 if not. The number of spaces to indent if so.
 */
static public int continueCount(int tagCode) {
    return TheContinuers[tagCode];
}

/**
 *
 */
static private final ObjDecl ODECL = ObjDecl.EMPTY;
