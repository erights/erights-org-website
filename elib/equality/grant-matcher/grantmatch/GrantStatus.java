package foresight.examples.grantmatch;

import foresight.examples.money.Purse;

/**
 * How a GrantMatcher client finds out what happened with its attempt
 * to contribute a matching grant.  The client provides a GrantStatus
 * as a call-back object in a contribution request.
 *
 * @see GrantMatcher#acceptMatch
 */
public interface GrantStatus {

    /**
     * Called back by the GrantMatcher if all was well
     */
    public void completionNotice();

    /**
     * If the GrantMatcher aborts the transaction, this is how it
     * returns any money it had escrowed from its clients.
     */
    public void refund(Purse money);
}

