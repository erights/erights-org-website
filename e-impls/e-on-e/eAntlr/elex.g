//----------------------------------------------------------------------------
// The E Lexer
//----------------------------------------------------------------------------
class ELexer extends Lexer;

options {
	importVocab=Common;
	exportVocab=ELexer;
	testLiterals=false;    // don't automatically test for literals
	k=4;                   // four characters of lookahead
	charVocabulary='\u0003'..'\u7FFE';
	// without inlining some bitset tests, couldn't do unicode;
	// I need to make ANTLR generate smaller bitsets; see
	// bottom of JavaLexer.java
	codeGenBitsetTestThreshold=20;
}

tokens {
    HEX;
    OCTAL;

    /* Keywords */
    "bind"; "break"; "catch"; "continue"; "def"; "else"; "escape"; "extends"; "finally"; "for"; "guards"; "if";
    "implements"; "in"; "interface"; "match"; "meta"; "method"; "pragma"; "return"; "switch"; "thunk"; "to";
    "try"; "var"; "when"; "while"; "_";

    /* pseudo-reserved keywords */
    "accum"; "delegate"; "module"; "on"; "select"; "throws";

    /* reserved keywords */
    "abstract"; "an"; "as"; "assert"; "attribute"; "be"; "begin"; "behalf"; "belief"; "believe"; "believes"; "case"; "class";
    "const"; "constructor"; "declare"; "default"; "define"; "defmacro"; "delicate"; "deprecated"; "dispatch";
    "do"; "encapsulate"; "encapsulated"; "encapsulates"; "end"; "ensure"; "enum"; "eventual"; "eventually";
    "export"; "facet"; "forall"; "function"; "given"; "hidden"; "hides"; "inline"; "is"; "know"; "knows";
    "lambda"; "let"; "methods"; "namespace"; "native"; "obeys"; "octet"; "oneway"; "operator"; "package";
    "private"; "protected"; "public"; "raises"; "reliance"; "reliant"; "relies"; "rely"; "reveal"; "sake";
    "signed"; "static"; "struct"; "suchthat"; "supports"; "suspect"; "suspects"; "synchronized"; "this";
    "transient"; "truncatable"; "typedef"; "unsigned"; "unum"; "uses"; "using"; "utf8"; "utf16"; "virtual";
    "volatile"; "wstring";
}

// OPERATORS
QUESTION		:	'?'		;
LPAREN			:	'('		;
RPAREN			:	')'		;
LBRACK			:	'['		;
RBRACK			:	']'		;
LCURLY			:	'{'		;
DOLLARCURLY  	:	"${"	;
ATCURLY       	:	"@{"	;
AT          	:	'@'	    ;
RCURLY			:	'}'		;
COLON			:	':'		;
COMMA			:	','		;
DOT		    	:	'.'		;
THRU			:	".."	;
TILL 			:	"..!"	;
SAME			:	"=="	;
LNOT			:	'!'		;
BNOT			:	'~'		;
NOTSAME		    :	"!="	;
DIV				:	'/'		;
FLOORDIV		:	"//"	;
PLUS			:	'+'		;
INC				:	"++"	;
MINUS			:	'-'		;
DEC				:	"--"	;
STAR			:	'*'		;
REM				:	'%'	    ;
MOD				:	"%%"	;
SR				:	">>"	;
GE				:	">="	;
GT				:	">"		;
SL				:	"<<"	;
LE				:	"<="	;
ABA				:	"<=>"	;
LT				:	'<'		;
BXOR			:	'^'		;
BOR				:	'|'		;
LOR				:	"||"	;
BAND			:	'&'		;
BUTNOT			:	"&!"	;
LAND			:	"&&"	;
SEMI			:	';'		;
POW 			:	"**"	;

ASSIGN			:	":="	;
FLOORDIV_ASSIGN	:	"//="	;
DIV_ASSIGN		:	"/="	;
PLUS_ASSIGN		:	"+="	;
MINUS_ASSIGN	:	"-="	;
STAR_ASSIGN		:	"*="	;
REM_ASSIGN		:	"%="	;
MOD_ASSIGN		:	"%%="	;
POW_ASSIGN		:	"**="	;
SR_ASSIGN		:	">>="	;
SL_ASSIGN		:	"<<="	;
BXOR_ASSIGN		:	"^="	;
BOR_ASSIGN		:	"|="	;
BAND_ASSIGN		:	"&="	;

/* Other funky tokens */
SEND			:	"<-"	;
WHEN			:	"->"	;
MAPSTO			:	"=>"	;
MATCHBIND       :	"=~"	;
MISMATCH		:	"!~"	;
SCOPE           :	"::"	;
//SCOPESLOT       :	"::&"	;

QUASIOPEN       : '`' {selector.push("quasi");}  ;

// Whitespace -- ignored
WS	    :	(	' ' | '\t' | '\f' )+    { $setType(Token.SKIP); }
        ;

EOL     :   (   (options {generateAmbigWarnings=false;} :
                "\r\n" | '\r' | '\n'
            )   { newline(); }  )+
	    ;

// Single-line comments
SL_COMMENT
	:	"#"
		(~('\n'|'\r'))* ('\n'|'\r'('\n')?)?
		{$setType(Token.SKIP); newline();}
	;

// multiple-line comments
ML_COMMENT
	:	"/**"
		(	/*	'\r' '\n' can be matched in one alternative or by matching
				'\r' in one iteration and '\n' in another.  I am trying to
				handle any flavor of newline that comes in, but the language
				that allows both "\r\n" and "\r" and "\n" to all be valid
				newline is ambiguous.  Consequently, the resulting grammar
				must be ambiguous.  I'm shutting this warning off.
			 */
			options {
				generateAmbigWarnings=false;
			}
		:
			{ LA(2)!='/' }? '*'
		|	'\r' '\n'		{newline();}
		|	'\r'			{newline();}
		|	'\n'			{newline();}
		|	~('*'|'\n'|'\r')
		)*
		"*/"
		{$setType(Token.SKIP);}
	;


// character literals
CHAR_LITERAL
	:	'\'' ( ESC | ~('\''|'\n'|'\r'|'\\') ) '\''
	;

// string literals
STRING_LITERAL
	:	'"' (ESC|~('"'|'\\'|'\n'|'\r'))* '"'
	;

// escape sequence -- note that this is protected; it can only be called
//   from another lexer rule -- it will not ever directly return a token to
//   the parser
// There are various ambiguities hushed in this rule.  The optional
// '0'...'9' digit matches should be matched here rather than letting
// them go back to STRING_LITERAL to be matched.  ANTLR does the
// right thing by matching immediately; hence, it's ok to shut off
// the FOLLOW ambig warnings.
protected
ESC
	:	'\\'
		(	'n'
		|	'r'
		|	't'
		|	'b'
		|	'f'
		|	'"'
		|	'\''
		|	'\\'
		|	('u')+ HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
		|	'0'..'3'
			(
				options {
					warnWhenFollowAmbig = false;
				}
			:	'0'..'7'
				(
					options {
						warnWhenFollowAmbig = false;
					}
				:	'0'..'7'
				)?
			)?
		|	'4'..'7'
			(
				options {
					warnWhenFollowAmbig = false;
				}
			:	'0'..'7'
			)?
		)
;


// hexadecimal digit
protected
HEX_DIGIT   :	('0'..'9'|'A'..'F'|'a'..'f')
;

// an identifier.  Note that testLiterals is set to true!  This means
// that after we match the rule, we look in the literals table to see
// if it's a literal or really an identifer
IDENT       options {testLiterals=true;}
	        :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*
	        ;

// a numeric literal
INT         :   ("0x") => "0x" (HEX_DIGIT)+ { $setType(HEX); }
            |   ('0' ('0'..'9')) => ('0'..'7')+  { $setType(OCTAL); }
            |   (POSINT ('.' | 'e' | 'E')) => FLOAT64  { $setType(FLOAT64); }
            |   POSINT
            ;

// an integer
protected
POSINT      :   '0' | ('1'..'9') ('0'..'9')*  ;

protected
FLOAT64     :   POSINT ('.' POSINT | ('e' | 'E') EXPONENT)  ;

protected
EXPONENT    :   ('+'|'-')? POSINT  ;
