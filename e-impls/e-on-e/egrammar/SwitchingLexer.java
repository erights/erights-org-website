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
abstract public class SwitchingLexer extends CharScanner {

    protected TokenMultiBuffer selector;
    protected String sourceURL;


    public SwitchingLexer(LexerSharedInputState sharedState) {
        inputState = sharedState;
    }

    public void setSelector(TokenMultiBuffer tb) {
        selector = tb;
    }

    public void setSourceURL(String nm) {
        sourceURL = nm;
    }

    public boolean atLineStart() {
        return inputState.tokenStartColumn <= 1;
    }
}
