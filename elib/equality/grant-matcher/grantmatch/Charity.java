package foresight.examples.grantmatch;

import foresight.examples.money.Purse;

/**
 * The kind of thing one can ask the Grant Matcher to give money to.
 */
public interface Charity {

    /**
     * How the Grant Matcher gives it money
     */
    public void acceptDonation(Purse donation);
}

