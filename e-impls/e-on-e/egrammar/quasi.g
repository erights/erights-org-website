
//class QuasiLexer extends Lexer("antlr.AstroLexer");
class QuasiLexer extends Lexer("antlr.SwitchingLexer");
options {
    importVocab=Common;
    testLiterals=false;    // don't automatically test for literals
    k=3;                   // four characters of lookahead
	charVocabulary='\3'..'\377';
    // unicode: charVocabulary='\u0003'..'\u7FFE';
	// without inlining some bitset tests, couldn't do unicode;
	// I need to make ANTLR generate smaller bitsets; see
	// bottom of JavaLexer.java
	codeGenBitsetTestThreshold=20;
}


//RCURLY      :   "}"     {selector.push("quasi");} ;  //reset after a
//protected DOLLARCURLY :   "${"    {selector.push("e");} ;
//protected DOLLARESC   :   "$\\"   ;
//protected ATCURLY     :   "@{"    {selector.push("e");} ;

QUASICLOSE: '`'         {selector.pop();}   ;

// TODO deal with double `

QUASIBODY:      ("${")=>"${"                        {$setType(DOLLARCURLY); selector.push("e");}
            |   ("@{")=>"@{"                        {$setType(ATCURLY); selector.push("e");}
            |   ('$' ('a'..'z'|'A'..'Z'|'_')) => '$'! IDENT {$setType(DOLLARHOLE);}
            |   ('@' ('a'..'z'|'A'..'Z'|'_')) => '@'! IDENT {$setType(ATHOLE);}
            |   QUASIx                              {$setType(QUASIBODY);}
            ;

protected
QUASIx:     (       ("$$") => "$$"
                |   ("$\\") => "$\\"
                |   ("@@") => "@@"
                |   ("@\\") => "@\\"  //so that it will check the predicate on the previous line
                //|   "``"
                |   ~('`'|'$'|'@'|'\r'|'\n')
                |   (options {generateAmbigWarnings=false;} :
                        "\r\n" | '\r' | '\n')   {newline();}
            )+;

protected
IDENT:      ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*  ;

protected
ESC:    '\\'
        (    'n'
        |    'r'
        |    't'
        |    'b'
        |    'f'
        |    '"'
        |    '\''
        |    '\\'
        |    ('u')+ HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
        |    '0'..'3'
            (
                options {
                    warnWhenFollowAmbig = false;
                }
            :    '0'..'7'
                (
                    options {
                        warnWhenFollowAmbig = false;
                    }
                :    '0'..'7'
                )?
            )?
        |    '4'..'7'
            (
                options {
                    warnWhenFollowAmbig = false;
                }
            :    '0'..'7'
            )?
        )
;

// hexadecimal digit
protected
HEX_DIGIT:       ('0'..'9'|'A'..'F'|'a'..'f')  ;
