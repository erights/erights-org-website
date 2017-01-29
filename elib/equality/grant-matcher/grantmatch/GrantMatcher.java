package foresight.examples.grantmatch;

import foresight.examples.money.*;
import java.math.BigInteger;

/**
 * The GrantMatcher accepts two messages attempting to give a matching
 * amount of money to the same Charity.  If both messages carry the
 * same amount of money, in the same currency, and both specify the same
 * Charity, the GrantMatcher will give the sum to the Charity.
 * Otherwise it will refund to each however much it escrowed.
 */
public abstract class GrantMatcher {

    /**
     * Private lock to prevent a locking attack.  Thanks Princeton
     * Folk!
     */
    private Object myLock = new Object();

    /**
     * 0 => initial conditions
     * 1 => one side has donated
     * 2 => completed, this Grant Matcher is used up.
     */
    private int myNumDonations = 0;

    private Currency myFirstCurrency;

    /**
     * Holds the money from the donors
     */
    private Purse myEscrow;

    /**
     * Where the first donor wishes the money to go
     */
    private Charity myFirstCharity = null;

    /**
     * To let the first donor know what happened
     */
    private GrantStatus myFirstCallback = null;

    /**
     * Anyone can creat a new GrantMatcher.  A new GrantMatcher does
     * not convey any authority.
     */
    protected GrantMatcher() {}

    /**
     * Process first donation
     */
    private void acceptFirst(Charity charity, Purse donation,
                             GrantStatus callback) {
        myNumDonations = 2; //in case we terminate abruptly
        myFirstCurrency = donation.currency();
        myEscrow = myFirstCurrency.newPurse();
        try {
            myEscrow.deposit(donation);
        } catch (DifferentCurrencyException ex) {
            throw new Error("internal: can't happen");
        }
        myFirstCharity = charity;
        myFirstCallback = callback;
        myNumDonations = 1;
    }

    /**
     * Process second donation
     */
    private boolean acceptSecond(Charity charity, Purse donation,
                                 GrantStatus callback) {
        myNumDonations = 2;
        BigInteger amount = myEscrow.balance();
        try {
            if (areEqual(charity, myFirstCharity)
                && donation.currency() == myFirstCurrency
                && amount.compareTo(myEscrow.deposit(donation)) == 0) {

                myFirstCharity.acceptDonation(myEscrow);
                return true;
            } else {
                return false;
            }
        } catch (DifferentCurrencyException ex) {
            return false;
        }
    }

    /**
     * Since the GrantMatcher exercise is about the consequences of
     * different choices of equality test, here we factor out the
     * crucial equality test to be provided by a subclass.
     */
    protected abstract boolean areEqual(Object x, Object y);

    /**
     * Asks the GrantMatcher to contribute 'donation' to 'charity' if
     * and only if someone else also contributes a matching donation
     * to the same charity.  'callback' is provided to find out the
     * status, and to receive a refund if a match isn't made.
     */
    public void acceptMatch(Charity charity, Purse donation,
                            GrantStatus callback) {

        BigInteger amount = myEscrow.balance();
        boolean successFlag;
        synchronized(myLock) {
            if (myNumDonations == 0) {
                acceptFirst(charity, donation, callback);
                return;
            } else if (myNumDonations == 1) {
                successFlag = acceptSecond(charity, donation, callback);
            } else {
                throw new RuntimeException("this GrantMatcher is used up");
            }
        }
        /*
         * Only call back after releasing the lock
         */
        if (successFlag) {
            myFirstCallback.completionNotice();
            callback.completionNotice();
        } else {
            try {
                myFirstCallback.refund(myEscrow.withdraw(amount));
            } catch (NegativeBalanceException ex) {
                throw new Error("internal: can't happen");
            }
            callback.refund(myEscrow);
        }
    }
}
