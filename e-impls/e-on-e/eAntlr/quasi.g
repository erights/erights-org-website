
class QuasiParser extends Parser;

options {
    k = 1;
    importVocab=Common;
    exportVocab=quasi;
    codeGenMakeSwitchThreshold = 2;  // Some optimizations
    codeGenBitsetTestThreshold = 3;
    buildAST = true;
}

//TODO add the quasi parsing logic here!

//quasiContent returns[AST ast]    :   q:QUASIBODY {ast = q;} QUASICLOSE
quasiContent    :   (   QUASIBODY
                    |   QIDENT
                    //|   QINT
                    |   exprHole
                    |   pattHole
                    )* {#quasiContent = #([QuasiContent], #quasiContent);}
                ;

exprHole        :   DOLLARCURLY!
                    {   EParser p = new EParser(getInputState());
                        p.eExpr();
                        #exprHole = p.getAST();
                        eMain.OurSelector.pop();
                    }
                    "}"
                ;

pattHole        :   ATCURLY!
                    {   EParser p = new EParser(getInputState());
                        p.pattern();
                        #pattHole = p.getAST();
                        eMain.OurSelector.pop();
                    }
                    "}"
                ;

class QuasiLexer extends Lexer;
options {
    exportVocab=quasi;
    testLiterals=false;    // don't automatically test for literals
    k=4;                   // four characters of lookahead
}

//RCURLY      :   "}"     {selector.push("quasi");} ;  //reset after a
DOLLARCURLY :   "${"    {selector.push("e");} ;
DOLLARESC   :   "$\\"   ;
ATCURLY     :   "@{"    {selector.push("e");} ;
QUASICLOSE  :   '`'     {selector.pop();}   ;

//QUASIBODY       :    (ESC | ~('`'|'$'|'@'))*
// TODO deal with double $, @, and `
// TODO deal $\ escapes
QUASIBODY   :    (~('`'|'$'|'@'))+ ;

QIDENT      :    '$'! ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*  ;

// Whitespace -- ignored
//WS        :    (    ' ' | '\t' | '\f' )+    { $setType(Token.SKIP); } ;

/*EOL       :   (   (options {generateAmbigWarnings=false;} :
                "\r\n" | '\r' | '\n'
            )   { newline(); }  )+
            ;

protected
ESC
    :    '\\'
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
HEX_DIGIT   :    ('0'..'9'|'A'..'F'|'a'..'f')
;
*/
QINT      :   '$'! ('0'..'9')+  ;
