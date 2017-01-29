package foresight.examples.grantmatch;

/**
 *
 */
public class EQGrantMatcher extends GrantMatcher {

    /**
     *
     */
    public EQGrantMatcher() {}

    /**
     *
     */
    protected boolean areEqual(Object x, Object y) {
        return x == y;
    }
}
