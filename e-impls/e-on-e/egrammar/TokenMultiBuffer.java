package antlr;

import java.util.Stack;

/**
 * Combines and interleaves multiple streams of tokents together into a single stream.
 * Actions during token recognition change the token stream to be provided.  This
 * simultaneously supports mark/rewind across changes in the token stream, recursive
 * use of token streams (for languages that nest in each other), and tracking of
 * such nesting (e.g., so if a nested language is terminated by a brack in an out
 * language.
 *
 * <p>
 *
 * Software rights: http://www.antlr.org/license.html
 *
 * @see antlr.TokenBuffer
 * @see antlr.Token
 * @see antlr.TokenQueue
 */
public class TokenMultiBuffer extends TokenBuffer {

    protected String[] myNames;
    protected TokenStream[] myInputs;
    protected Stack myMarkStreams = new Stack();
    protected MarkRecord myLayers = null;

    protected int myEnterCount = 0;

    /** Create a token buffer */
    public TokenMultiBuffer(TokenStream input_) {
        this(new String[]{"base"}, new TokenStream[]{input_});
    }

    public TokenMultiBuffer(String[] names, TokenStream[] inputs) {
        myNames = names;
        myInputs = inputs;
        input = myInputs[0];
    }

    public void push(String name) {
        myLayers = new MarkRecord(myEnterCount, input, myLayers);
        myEnterCount = 0;
        select(findInput(name));
        trace("push");
    }

    public void pop() {
        trace("pop");
        //TODO check for myNesting==0?
        input = myLayers.stream;
        myEnterCount = myLayers.enterCount;
        myLayers = myLayers.next;
    }

    public void enterBrace() {
        trace("enter");
        myEnterCount++;
    }
    public void exitBrace() {
        trace("exit");
        if (myEnterCount <= 0) {
            pop();
        } else {
            myEnterCount--;
        }
    }

    public void select(int streamNum) {
        input = myInputs[streamNum];
    }
    public void select(String name) {
        input = myInputs[findInput(name)];
        trace("select");
    }
    public int findInput(String name) {
        for (int i = 0, max = myInputs.length; i<max; i++) {
            if (myNames[i].equals(name)) {
                return i;
            }
        }
        return -1; //not a great default, but ensures an error
    }
    public String findName(TokenStream ts) {
        for (int i = 0, max = myInputs.length; i<max; i++) {
            if (myInputs[i] == ts) {
                return myNames[i];
            }
        }
        return "unknown";
    }
    public final int mark() {
//        myMarkStreams.push(new MarkRecord(myEnterCount, input, myLayers));
        trace("mark");
        return super.mark();
    }

    public final void rewind(int mark) {
        super.rewind(mark);
//        MarkRecord r = (MarkRecord) myMarkStreams.pop();
//        myEnterCount = r.enterCount;
//        input = r.stream;
//        myLayers = r.next;
        trace("rewind");
    }

    private class MarkRecord {
        final int enterCount;
        final TokenStream stream;
        final MarkRecord next;
        MarkRecord(int count, TokenStream s, MarkRecord n) {
            enterCount = count;
            stream = s;
            next = n;
        }
    };

    private void trace(String header) {
//        System.err.print(header + " [" + findName(input));
//        for (MarkRecord r = myLayers; r != null; r = r.next) {
//            System.err.print(", " + findName(r.stream));
//        }
//        System.err.println("]");
//        Thread.dumpStack();
    }

}
