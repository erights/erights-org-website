class EParser extends Parser;

options {
	k = 2;                           // one token lookahead
	importVocab=ELexer;
	exportVocab=E;
	codeGenMakeSwitchThreshold = 2;  // Some optimizations
	codeGenBitsetTestThreshold = 3;
	buildAST = true;
}

tokens {
    RunExpr;
    GetExpr;
    AssignExpr;
    CallExpr;
    DefineExpr;
    EscapeExpr;
    HideExpr;
    IfExpr;
    ForExpr;
    LiteralExpr;
    MatchBindExpr;
    NounExpr;
    ObjectExpr;
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
    TupleExpr;
    BindPattern;
    SendExpr;

    FinalPattern;
    VarPattern;
    SlotPattern;
    ListPattern;
    CdrPattern;
    IgnorePattern;
    SuchThatPattern;
    QuasiLiteralPattern;
    QuasiPatternPattern;

    EScript;
    EMethod;
    EMatcher;

}


start       :   br (seq)? ;

br          :   (EOL!)* ;

seq         :   eExpr (((SEMI! | EOL!) (eExpr)?)+ {#seq = #([SeqExpr],seq);} )?  ;

eExpr       :   (assign | ejector assign)   ;

basic       :   ifExpr | forExpr | whileExpr | switchExpr | tryExpr | escapeExpr  ;

ifExpr      :   "if"^ parenExpr body
                ("else"! (ifExpr | body ))?                     {#ifExpr.setType(IfExpr); }
            ;

forExpr     :   "for"^ iterPattern "in" assign body (catcher)?  {#forExpr.setType(ForExpr);}
            |   "when"^ iterPattern "in" assign body            {#forExpr.setType(ForExpr);}
            ;

whileExpr   :   "while"^ parenExpr body  {#whileExpr.setType(WhileExpr);}
                (catcher)?
            ;

escapeExpr  :   "escape"^ pattern body (catcher)?               {#escapeExpr.setType(EscapeExpr);}
            ;

switchExpr  :   "switch"^ parenExpr
                LBRACK! br ("match"! pattern body)* RBRACK!    {#switchExpr.setType(SwitchExpr);}
            ;

tryExpr     :   "try"^ body ("catch"! pattern body)* {#tryExpr.setType(TryExpr);}
                ("finally"^ body {#tryExpr.setType(FinallyExpr);})?
            ;

body        :   LCURLY! br (RCURLY! | seq RCURLY!)
            ;

// rules for expressions follow the pattern:
//   thisLevelExpression :  nextHigherPrecedenceExpression (OPERATOR nextHigherPrecedenceExpression)*
// which is a standard recursive definition for a parsing an expression.
assign      :	cond
                (	ASSIGN^ assign                  {#assign.setType(AssignExpr);}
                |	assignOp assign                 {#assign = #([AssignExpr], #assign);}  )?
            |   "def"^  (   (pattern ASSIGN) => pattern ASSIGN! assign
                        |   noun   // forward declaration
                        ) {#assign.setType(DefineExpr);}
            |   binder          ASSIGN^ assign      {#assign.setType(DefineExpr);}
            |   varNamer        ASSIGN^ assign      {#assign.setType(DefineExpr);}
	        ;

assignOp    :	FLOORDIV_ASSIGN | PLUS_ASSIGN | MINUS_ASSIGN | STAR_ASSIGN | DIV_ASSIGN
            |   REM_ASSIGN | MOD_ASSIGN | POW_ASSIGN | SR_ASSIGN | SL_ASSIGN | BAND_ASSIGN
            |   BXOR_ASSIGN | BOR_ASSIGN
            ;

ejector     :   "break"^            {#ejector.setType(BreakExpr);}
            |   "continue"^         {#ejector.setType(ContinueExpr);}
            |   "return"^           {#ejector.setType(ReturnExpr);}
            |   XOR^                {#ejector.setType(ReturnExpr);}
            ;

// || is don't-care associative
cond        :   condAnd (LOR^ condAnd)*
            ;
// && is don't-care associative
condAnd     :   logical (LAND^ logical)*
            ;

// ==, !=, &, |, ^, =~, and !~ are all non associative with each
// other.  & and |, normally used for associative operations, are each
// made associative with themselves. None of the others even associate
// with themselves. Perhaps ^ should?
logical     :   order
                (   SAME^ order
                |   NOTSAME^ order
                |   (BAND^ order)+
                |   (BOR^ order)+
                |   (BXOR^ order)+
                |   BUTNOT^ order
                |   MATCHBIND^ pattern
                |   MISMATCH^ pattern
                |   )   //empty
            ;

order       :   interval
                (   compOp interval {#order = #([CallExpr], order);}
                |   COLON^ guard
                |   )  // empty
            ;

compOp      :  LT | LE | ABA | GE | GT ;

// .. and ..! are both non-associative (no plural form)
interval    :   shift ((THRU^ | TILL^) shift)?
            ;

// << and >> are left-associative (no plural form)
shift       :   add ((SL^ | SR^) add)*
            ;

//+ and - are left associative
add         :   mult ((PLUS^ | MINUS^) mult)*
            ;

// *, /, //, %, and %% are left associative
mult        :   pow ((STAR^ | DIV^ | FLOORDIV^ | REM^ | MOD^) pow)*
            ;

// ** is non-associative
pow         :   prefix (POW^ prefix)?
            ;

// Unary prefix !, ~, &, *, and - are non-associative.
// Unary prefix !, ~, &, and * bind less tightly than unary postfix.
// Unary prefix -, because it will often be mistaken for part of a literal
// number rather than an operator, is not combinable with unary postfix, in
// order to avoid the following surprise:
//      -3.pow(2) ==> -9
// If -3 were a literal, the answer would be 9. So, in E, you must say either
//      (-3).pow(2)  or -(3.pow(2))
// to disambiguate which you mean.
prefix      :   postfix
            | LNOT^ postfix
            | BNOT^ postfix
            | BAND^ postfix
            | STAR^ postfix
            | PLUS^ postfix
            | MINUS^ prim
            ;

// Calls and sends are left associative.
postfix     :   call
            // TODO deal with verb curries and properties
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
call        :   prim
                (   parenArgs               { #call = #([CallExpr,"run"], [STRING_LITERAL,"run"], #call); }
                |   DOT^ verb parenArgs     { #call.setType(CallExpr); }
                |   LBRACK^ br argList RBRACK! { #call.setType(GetExpr); }
                |   SEND^ (verb parenArgs | parenArgs) { #call.setType(SendExpr); }
                )*
            ;

parenArgs   :   LPAREN! argList RPAREN! //(body)?
            //| body
            ;

argList     :   (eExpr (COMMA! argList)?)?
            ;

prim        :   literal
            |   basic
            |   nounExpr (quasiString {#prim = #([QuasiLiteralExpr], #prim);})?
            |   parenExpr (quasiString {#prim = #([QuasiLiteralExpr], #prim);})?
            |   quasiString
            |   LBRACK^ br argList RBRACK!     { #prim.setType(TupleExpr); }
            |   body                           { #prim.setType(HideExpr); }
            ;

//Property names for use e.g., with the :: syntax.
// Should the "&" handling be here?
prop        :   IDENT | STRING_LITERAL
            ;

// a method selector
verb        :   IDENT | STRING_LITERAL
            ;

literal     :   STRING_LITERAL | CHAR_LITERAL | INT | FLOAT64 | HEX | OCTAL
            ;

noun        :   IDENT
            |   "%" LiteralString
            |   "%%" LiteralString
            |   "::" LiteralString
            ;

guard       :   IDENT  //order  // hack
            ;

catcher     :   "catch"! pattern body
            ;

// Patterns
iterPattern :   pattern
            ;

pattern     :   listPatt (QUESTION^ order)?
            ;

listPatt    :   eqPatt
            |   LBRACK^ br
                (   (key MAPSTO!) => mapPattList RBRACK! (BOR listPatt)?  {#listPatt.setType(MapPattern);}
                |   patternList RBRACK! (PLUS! listPatt)?   {#listPatt.setType(ListPattern);}
                )
            ;

eqPatt      :   quasiPatt
            |   SAME^ prim
            |   NOTSAME^ prim
            |   compOp prim
            ;

quasiPatt   :   namer
            |   quasiString
            |   (IDENT QUASIOPEN) => IDENT quasiString
            |   parenExpr quasiString
            ;

quasiString :   QUASIOPEN!
                {   QuasiParser p = new QuasiParser(getInputState());
                    p.quasiContent();
                    #quasiString = p.getAST();}
                QUASICLOSE!  // sneaky trick: '`' is the QUASICLOSE token in the quasi lexer
                ;
//quasiString :   QUASI!  {new QuasiParser(getInputState()).quasiContent();}  QUASI!   ;

key         :   parenExpr | literal
            ;

parenExpr   :   LPAREN! br seq RPAREN!  ;

// Namers are patterns that bind at most one name.
namer       :   nounExpr (COLON! guard)?    {#namer.setType(FinalPattern);}
            |   "_" (COLON! guard)?         {#namer.setType(IgnorePattern);}
            |   binder
            |   varNamer
            |   slotNamer
            ;

binder      :   "bind"^ noun (COLON! guard)?        {#binder.setType(BindPattern);}
            ;

varNamer    :   "var"^ nounExpr (COLON! guard)?     {#varNamer.setType(VarPattern);}
            ;

slotNamer   :   LAND^ nounExpr (COLON! guard )?     {#slotNamer.setType(SlotPattern);}
            ;

nounExpr    :   noun
            |   dollarHole                      {#nounExpr.setType(QuasiLiteralPattern);}
            |   atHole                          {#nounExpr.setType(QuasiPatternPattern);}
            ;

dollarHole  :   "${" LiteralInteger RCURLY
            |   "$" LiteralInteger
            |   "$$"
            ;

atHole      :   ATCURLY^ POSINT RCURLY!
            |   AT POSINT
            ;

patternList :   (eqPatt (COMMA! patternList)?)? ;

mapPattList :   (key MAPSTO (COMMA! mapPattList)?)? ;

mapPattern  :   key MapsTo^ pattern (ASSIGN order)?
            |   MapsTo namer (ASSIGN order)?
            ;

/**
 * The name pattern, or literal name, for an object definition
 * expression
 */
oName       :   nounExpr
            |   "_"
            |   BIND noun
            |   VAR nounExpr
            |   STRING_LITERAL
            ;
