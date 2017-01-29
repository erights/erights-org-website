package antlr;

import org.quasiliteral.astro.AstroSchema;
import org.quasiliteral.astro.AstroBuilder;
import org.quasiliteral.astro.BaseSchema;
import org.quasiliteral.antlr.ASTBuilder;
import org.quasiliteral.antlr.AstroToken;
import org.erights.e.elib.base.SourceSpan;

/**
 * Created by IntelliJ IDEA.
 * User: Dean Tribble
 * Date: Jan 13, 2005
 * Time: 9:20:54 PM
 * To change this template use Options | File Templates.
 */
abstract public class AstroLexer extends SwitchingLexer {

    public AstroLexer(LexerSharedInputState sharedState) {
        super(sharedState);
    }

    protected Token makeToken(int t) {
        SourceSpan span =
                new SourceSpan(
                        sourceURL,
                        false,
                        inputState.tokenStartLine,
                        inputState.tokenStartColumn,
                        inputState.line,
                        inputState.column);
        Token tok = new AstroToken(span);
        tok.setType((short) t);
        return tok;
    }


}
