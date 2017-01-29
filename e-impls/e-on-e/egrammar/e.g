// Copyright 2004-2005 Dean Tribble under the terms of the MIT X license
// found at http://www.opensource.org/licenses/mit-license.html

// @author Dean Tribble

// A pattern to produce a possibly empty list of xItem separated and optionally followed
// by commas, we need to use a special construction:
//   xItemList   :   (xItem (","! xItemList)?)? ;
// note that this cannot be an empty list with a comma.

// A caret after a terminal pulls that terminal out and makes it the parent node of the tree currently being built.
// An exclamation after a element suppresses generation of a node for that terminal

// Actions in the parse are enclosed in curlies.  Antlr provides some special syntax for tree construcion:
// ## refers to the result node of this production.
// Assigning to ## specifies the tree that will be produced.  All following terminals will be appended
//         as siblings to the children of that node.
// #name refers to the named AST node

// Two patterns are commonly used to create the tree below:
// 1) add a caret to a terminal that would otherwise be suppressed, then change the resulting root's type:
//           assign : cond ":="^ assign   {##.setType(AssignExpr);} ;
//    elevates the ":=" to be the parent of the "cond" and "assign" nodes, then sets its type to AssignExpr
// 2) create a new node using Antlr's creation syntax:
//           assign : cond ":="! assign   {##=#([AssignExpr],##);} ;
//    suppressed the ":=" node, then assigns the result node to a newly created tree with
//    a newly created AssignExpr node at the root, and all the previous nodes (cond and assign) as children

//scala

// MARK: why are guards and patterns different.  Whay aren't guards a kind of pattern?  That would also make ":" and "=~" the same.

// ? what does \<LF> mean in a string literal
//      . \ followed by only whitespace suppressed the newline and the whitespace
//      ? should this also apply to quasiquote
// ? are updoc line headers only at the first character, or the first non-WS character?
//      . should be first non-whitespace character
// ? is there a BR *before* the => of a map pattern/expr?
// ? isn't verb= deprecated?
//      . no.  it's in the lexer for old grammar, but should be in the parser
// ? makeKiosk has an inequality guard.  not supported?
//
// ? menuMakerAuthor has complicated guards (with <>, etc.)

//MARK:  forExprs can have a break after the keyword.  What about other constructs?


class EParser extends Parser;

options {
	k = 2;                           // number of token lookahead
	importVocab=Common;
	exportVocab=E;
	codeGenMakeSwitchThreshold = 2;  // Some optimizations
	codeGenBitsetTestThreshold = 3;
	buildAST = true;
}

tokens {
    AssignExpr;
    CallExpr;
    DefineExpr;
    EscapeExpr;
    HideExpr;
    IfExpr;
    ForExpr;
    WhenExpr;
    AndExpr;
    OrExpr;
    CoerceExpr;
    LiteralExpr;
    MatchBindExpr;
    NounExpr;
    ObjectExpr;
    InterfaceExpr;
    QuasiLiteralExpr;
    QuasiPatternExpr;
    MetaStateExpr;
    MetaContextExpr;
    SeqExpr;
    SlotExpr;
    MetaExpr;
    CatchExpr;
    FinallyExpr;

    ReturnExpr;
    ContinueExpr;
    BreakExpr;
    WhileExpr;
    SwitchExpr;
    TryExpr;
    MapPattern;
    LiteralPattern;
    TupleExpr;
    MapExpr;
    BindPattern;
    SendExpr;
    CurryExpr;

    FinalPattern;
    VarPattern;
    SlotPattern;
    ListPattern;
    CdrPattern;
    IgnorePattern;
    SuchThatPattern;
    QuasiLiteralPattern;
    QuasiPatternPattern;
    URI;
    URIStart;
    URIGetter;
    URIExpr;
    LambdaExpr;

    EScript;
    EMethod;
    EMatcher;
    List;
    WhenFn;

    //for lexer
    HEX;
    OCTAL;
    WS;
    LINESEP;
    SL_COMMENT;
    DOC_COMMENT;
    CHAR_LITERAL;
    STRING;
    ESC;
    HEX_DIGIT;
    IDENT;
    INT;
    POSINT;
    FLOAT64;
    EXPONENT;

}
{   // support for nesting parsers
    protected antlr.TokenMultiBuffer selector;
    public void setSelector(antlr.TokenMultiBuffer sel) {
        selector = sel;
    }
}

//TODO

start:          br (seq)? ;

br:             (LINESEP!)* ;

seq:            eExpr (((";"! | LINESEP!) (eExpr)?)+    {##=#([SeqExpr],##);}   )?  ;

eExpr:          assign | ejector ;

basic:          ifExpr | forExpr | whileExpr | switchExpr | tryExpr | escapeExpr | whenExpr
            |   lambdaExpr ;

ifExpr:         "if"^ parenExpr body
                ("else"! (ifExpr | body ))?                     {##.setType(IfExpr);}
            ;

forExpr:        "for"^ pattern ("=>" pattern)? "in"! br assign body (catcher)?  {##.setType(ForExpr);}  ;

whenExpr:       "when"^ (parenArgs)? br "->"!  whenFn
                (catcher)* ("finally" body)?   {##.setType(WhenExpr);}
            ;

whenFn:         objName params (":"! guard)? body   {##=#([WhenFn],##);}  ;

whileExpr:      "while"^ parenExpr body  {##.setType(WhileExpr);}
                (catcher)?
            ;

escapeExpr:     "escape"^ pattern body (catcher)?        {##.setType(EscapeExpr);}  ;

lambdaExpr:     "thunk"^ body    {##.setType(LambdaExpr);}  ;

switchExpr:     "switch"^ parenExpr
                "{"! (matcher br)* "}"!    {##.setType(SwitchExpr);}
            ;

tryExpr:        "try"^ body
                (catcher)*
                ("finally"! body)?                      {##.setType(TryExpr);}
            ;

binder:         "bind"^ noun (":"! guard)?      {##.setType(BindPattern);}  ;

varNamer:       "var"^ nounExpr (":"! guard)?   {##.setType(VarPattern);}  ;

slotNamer:      "&"^ nounExpr (":"! guard )?    {##.setType(SlotPattern);} ;

// should forward declaration allow types?
defExpr:        doco  // I think that all these cases should allow doco, but in any case
                "def"^  (  (objectPredict)  => objName objectExpr            {##.setType(ObjectExpr);}
                        |  (pattern ":=") => pattern ":="! assign    {##.setType(DefineExpr);}
                        |  bindName       {##.setType(DefineExpr);}  // forward declaration
                        )
            |   "bind"! bindExpr
            |   "var"! bindExpr
            ;

//TODO
interfaceExpr:  "interface"^  objName
                    //(typeParams)?
                    //(":"! guard)?
                    ("extends" br order ("," order)*)?     // trailing comma would be ambiguous with HideExpr
                    ("implements" br order ("," order)*)?  // trailing comma would be ambiguous with HideExpr
                    "{"^ (doco method br)* (matcher br)* "}"!
                    {##.setType(InterfaceExpr);}
            ;

 //|      INTERFACE oName typeParams guards iDeclTail '{' br mTypeList '}'

bindExpr:       bindName //(":"! guard)?
                (   ":="! assign {##.setType(DefineExpr);}
                |   objectExpr                {##.setType(ObjectExpr);}
                )
            ;

defPatt:        (         {##.setType(FinalPattern);}
                | "var"   {##.setType(VarPattern);}
                | "bind"  {##.setType(BindPattern);}  )
                (nounExpr | "_" | STRING)
            ;

// minimize the look-ahead for objectExpr
objectPredict:    objName ("extends" | "implements" | "{"| "(" ) ;
objectExpr:     //(typeParams)?
        //(":"! guard)?
                (   ("extends" br order)?
                    ("implements" br order ("," order)*)?  // trailing comma would be ambiguous with HideExpr
                    script
                |   params resultGuard body      // function
                )
            ;

// The name pattern, or literal name, for an object definition
bindName:   (   nounExpr         {##=#([FinalPattern],##);}
                |   "&"^ nounExpr    {##.setType(SlotPattern);}
                |   STRING           {##=#([LiteralPattern],##);})
            (":"! guard)?
            ;

objName:        nounExpr         {##=#([FinalPattern],##);}
            |   "_"^             {##.setType(IgnorePattern);}
            |   "bind"^ noun     {##.setType(BindPattern);}
            |   "var"^ nounExpr  {##.setType(VarPattern);}
            |   "&"^ nounExpr    {##.setType(SlotPattern);}
            |   STRING           {##=#([LiteralPattern],##);}
            ;

//MARK: what is typeParams for?  it appears to come right after "def name"
typeParams:     "[" typePatternList br "]" ;  // should have a br before the "]"

typePatternList:    (nounExpr (":"! guard)? ("," typePatternList)?)? ;

script:         "{"^ (doco method br)* (matcher br)* "}"!  {##.setType(EScript);} ;
// TODO need to deal with doco for matcher

method:         (   "to"^ methHead body
                |   "method"^ methHead body
                |   "on"^ methHead body
                //|   DEF field OpAss assign
                //|   VAR field OpAss assign

                //|   TO field body
                //|   TO field OpAss pattern body
                //|   TO '&' field body

                //|   META parenExpr body
                //|   META parenExpr MapsTo parenExpr
                ) {##.setType(EMethod);}
            ;

matcher:       "match"^ pattern body  {##.setType(EMatcher);} ;

methHead:            params resultGuard
            |   verb params resultGuard
            ;

params:         "("! patternList br ")"!   {##=#([List],##);} ;
patternList:    (pattern (","! patternList)?)? ;

resultGuard:    (":"! guard)? ("throws" guardList)? ;
guardList:      guard (","! guard)* ;    // requires at least one guard. cannot end with comma

doco:           (DOC_COMMENT)? ; // The current E grammar only let's you put these in a few places.

body:           "{"! (seq)? "}"! ;

// rules for expressions follow the pattern:
//   thisLevelExpression :  nextHigherPrecedenceExpression (OPERATOR nextHigherPrecedenceExpression)*
// which is a standard recursive definition for a parsing an expression.
assign:      	cond
                (	":="^ assign                  {##.setType(AssignExpr);}
                |	assignOp assign               {##=#([AssignExpr], ##);}
                |	verb "="! assign              {##=#([AssignExpr], ##);}  )?
            |   defExpr
	        ;

assignOp:    	"//=" | "+=" | "-=" | "*=" | "/="
            |   "%=" | "%%=" | "**=" | ">>=" | "<<=" | "&="
            |   "^=" | "|="
            ;

ejector:        (   "break"^         {##.setType(BreakExpr);}
                |   "continue"^      {##.setType(ContinueExpr);}
                |   "return"^        {##.setType(ReturnExpr);}
                ) (("(" ")") => "(" ")" | assign | )
            |   "^"^ assign          {##.setType(ReturnExpr);}
            ;

// || is don't-care associative
cond:           condAnd ("||"^ condAnd  {##.setType(OrExpr);})*
            ;
// && is don't-care associative
condAnd:        logical ("&&"^ logical  {##.setType(AndExpr);})*
            ;

// ==, !=, &, |, ^, =~, and !~ are all non associative with each
// other.  & and |, normally used for associative operations, are each
// made associative with themselves. None of the others even associate
// with themselves. Perhaps ^ should?
logical:        order
                (   (   "==" order
                    |   "!=" order
                    |   "&!" order
                    |   "=~" pattern
                    |   "!~" pattern
                    ) {##=#([CallExpr],##);}
                |   ({##=#([CallExpr],##);}  "^" order)+
                |   ({##=#([CallExpr],##);}  "&" order)+
                |   ({##=#([CallExpr],##);}  "|" order)+
                )?   //optional
            ;

order:          interval
                (   compareOp interval {##=#([CallExpr], ##);}
                |   ":"^ guard      {##.setType(CoerceExpr);}
                |   )  // empty
            ;

// The br for ">" is because it is used to close URIs, where it cannot have a br.
compareOp:        "<" | "<=" | "<=>" | ">=" | ">" br ;

// .. and ..! are both non-associative (no plural form)
interval:       shift ({##=#([CallExpr],##);}   (".." | "..!") shift)?  ;

// << and >> are left-associative (no plural form)
shift:          add ({##=#([CallExpr],##);}     ("<<" | ">>") add)*   ;

//+ and - are left associative
add:            mult ({##=#([CallExpr],##);}    ("+" | "-") mult)*   ;

// *, /, //, %, and %% are left associative
mult:           pow ({##=#([CallExpr],##);}     ("*" | "/" | "//" | "%" | "%%") pow)*  ;

// ** is non-associative
pow:            prefix ("**" prefix     {##=#([CallExpr], ##);}    )?  ;

// Unary prefix !, ~, &, *, and - are non-associative.
// Unary prefix !, ~, &, and * bind less tightly than unary postfix.
// Unary prefix -, because it will often be mistaken for part of a literal
// number rather than an operator, is not combinable with unary postfix, in
// order to avoid the following surprise:
//      -3.pow(2) ==> -9
// If -3 were a literal, the answer would be 9. So, in E, you must say either
//      (-3).pow(2)  or -(3.pow(2))
// to disambiguate which you mean.
prefix:         postfix
            |!  op:prefixOp  a:postfix          {##=#([CallExpr],a,op);}
            |!  neg:"-" b:prim                  {##=#([CallExpr],b,neg);}
            ;

prefixOp:     ("!" | "~" | "&" | "*" | "+") ;
// Calls and sends are left associative.
postfix:        call
            // TODO deal with properties
            ;

call:           p:prim
                (!  a:parenArgs              { ##=#([CallExpr,"run"], p, [STRING,"run"], a); }
                |   "."^ message             { ##.setType(CallExpr); }
                |!  "["^ l:argList br "]"!   { ##=#([CallExpr,"get"], p, [STRING,"get"], l); }
                |   "<-"^ (parenArgs | message) { ##.setType(SendExpr); }
                )*
            ;

message:        v:verb (("(") => parenArgs
                       | {#v.setType(CurryExpr);})   // curry
            ;

parenArgs:      "("! argList br ")"!  ; //(body)? | body  ;

argList:        (eExpr (","! argList)?)? ;

prim:           literal
            |   basic
            |   nounExpr  (quasiString   {##=#([QuasiLiteralExpr],##);}  )?
            |   parenExpr (quasiString   {##=#([QuasiLiteralExpr],##);}  )?
            |   quasiString              {##=#([QuasiLiteralExpr,"simple"],[STRING,"simple"],##);}
            |   URI                      {##=#([URIExpr],##);}
            |   URIStart add ">"!        {##=#([URIExpr],##);}
            //|   "<"^ nounExpr (":"! add)? ">"! {##.setType(URIExpr);}
            |   "["^
                (   (eExpr "=>") => mapList    {##.setType(MapExpr);}
                |   argList                    {##.setType(TupleExpr);}
                ) br "]"!
            |   body                     {##=#([HideExpr],##);}
            ;

mapList:        (map (","! mapList)?)? ;

map:            eExpr "=>"^ eExpr
            |   "=>"^ (nounExpr
                      | "&"nounExpr
                      | "def" nounExpr )
            ;

//Property names for use e.g., with the :: syntax.
// Should the "&" handling be here?
prop:           IDENT | STRING
            ;

// a method selector
verb:           IDENT | STRING  ;

literal:        STRING | CHAR_LITERAL | INT | FLOAT64 | HEX | OCTAL  ;

noun:           IDENT
            |   "%" LiteralString
            |   "%%" LiteralString
            |   "::" LiteralString
            ;

// a valid guard is an identifier, and guard followed by [argList], or parenExpr
guard:      (nounExpr | parenExpr)
                    ("["
                      ( (eExpr "=>") => eExpr "=>" eExpr     {##.setType(MapExpr);}
                        |   argList                          {##.setType(TupleExpr);}
                      ) br "]"!)*
            ;

//argList:        (eExpr (","! argList)?)? ;

catcher:        "catch"^ pattern body ;

// Patterns
pattern:        listPatt ("?"^ order  {##.setType(SuchThatPattern);}  )?   ;

listPatt:       eqPatt
            |   "["^
                 //  patternList br "]"! ("+"! listPatt)?               {##.setType(ListPattern);}
                (   (key "=>") => mapPattList br "]"! ("|" listPatt)?  {##.setType(MapPattern);}
                |   patternList br "]"! ("+"! listPatt)?               {##.setType(ListPattern);}
                )
            ;

eqPatt:         nounExpr
                (   (":"! guard)?       {##=#([FinalPattern],##);}
                |   quasiString         {##=#([QuasiLiteralPattern],##);} // was IDENT quasiString
                )
            |   "_"^ (":"! guard)?      {##=#([IgnorePattern],##);}
            |   "=="^ prim
            |   "!="^ prim
            |   compareOp prim
            |   quasiString             {##=#([QuasiLiteralPattern,"simple"],[STRING,"simple"],##);}
            |   parenExpr quasiString   {##=#([QuasiLiteralPattern],##);}
            |   binder
            |   varNamer
            |   slotNamer
            // shouldn't def also be allowed here.
            ;

// namePatts are patterns that bind at most one name.
// this is expanded inline into eqPatt, but used directly elsewhere
namePatt:       nounExpr (":"! guard)?    {##=#([FinalPattern],##);}
            |   "_"^ (":"! guard)?        {##.setType(IgnorePattern);}
            |   binder
            |   varNamer
            |   slotNamer
            ; // STRING???

nounExpr:       noun
            |   URIGetter                       {##=#([URIExpr],##);}
            |   dollarHole                      {##.setType(QuasiLiteralPattern);}
            |   atHole                          {##.setType(QuasiPatternPattern);}
            ;

dollarHole:     "${" LiteralInteger "}"
            |   "$" LiteralInteger
            |   "$$"
            ;

atHole:         "@{"^ POSINT "}"!
            |   "@" POSINT
            ;

key:            parenExpr | literal  ;

parenExpr:      "("! seq ")"!  ;
//args        :   "("! br seq ")"!  ;

mapPattList:    (key "=>"! (","! mapPattList)?)? ;

mapPattern:     key MapsTo^ pattern (":=" order)?
            |   MapsTo namePatt (":=" order)? // BLECH
            ;

// QUASI support
quasiString:    QUASIOPEN!
                (   exprHole
                |   pattHole
                |   QUASIBODY
                |   DOLLARHOLE
                |   ATHOLE
                )* {##=#([QuasiContent],##);}
                QUASICLOSE!  // NOTE: '`' is the QUASICLOSE token in the quasi lexer
            ;

exprHole:       DOLLARCURLY^
                br eExpr br {##.setType(DOLLARHOLE);}
                //({selector.select("quasi");}:)
                "}"!
            ;

pattHole:       ATCURLY!
                br pattern br {##.setType(ATHOLE);}
                //({selector.select("quasi");}:)
                "}"!
            ;

/* // makes grammar compilation take too long
reserved:     "fn" | "fun" | "datatype" | "guards" | "interface" | "meta" | "method" | "pragma" | "thunk"
            | "accum" | "delegate" | "module" | "select" | "throws" | "abstract" | "an" | "as" | "assert"
            | "attribute" | "be" | "begin" | "behalf" | "belief" | "believe" | "believes" | "case" | "class"
            | "const" | "constructor" | "declare" | "default" | "define" | "defmacro" | "delicate" | "deprecated"
            | "dispatch" | "do" | "encapsulate" | "encapsulated" | "encapsulates" | "end" | "ensure" | "enum"
            | "eventual" | "eventually" | "export" | "facet" | "forall" | "function" | "given" | "hidden"
            | "hides" | "inline" | "is" | "know" | "knows" | "lambda" | "let" | "methods" | "namespace"
            | "native" | "obeys" | "octet" | "oneway" | "operator" | "package" | "private" | "protected"
            | "public" | "raises" | "reliance" | "reliant" | "relies" | "rely" | "reveal" | "sake" | "signed"
            | "static" | "struct" | "suchthat" | "supports" | "suspect" | "suspects" | "synchronized" | "this"
            | "transient" | "truncatable" | "typedef" | "unsigned" | "unum" | "uses" | "using" | "utf8"
            | "utf16" | "virtual" | "volatile" | "wstring" ;
*/
/*/**/

