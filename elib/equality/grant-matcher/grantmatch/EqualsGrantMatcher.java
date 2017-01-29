package foresight.examples.grantmatch;

/**
 *
 */
public class EqualsGrantMatcher extends GrantMatcher {

    /**
     *
     */
    public EqualsGrantMatcher() {}

    /**
     *
     */
    protected boolean areEqual(Object x, Object y) {
        return x.equals(y);
    }
}
