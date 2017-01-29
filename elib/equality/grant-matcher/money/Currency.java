package foresight.examples.money;

/**
 * Each currency is represented by a unique Currency object.
 *
 * @see Mint
 */
public class Currency {

    /**
     * Hidden lock to prevent locking attacks. Thanks Princeton Folk!
     */
    /*package*/ Object myLock = new Object();

    /**
     * Currencies are only created by Mints.
     */
    /*package*/ Currency() {}

    /**
     * Creates a new empty Purse for cash in this currency.  The new
     * Purse is initially held exclusively by the caller.  While an
     * empty Purse contains no cash, if you are holding a Purse
     * potentially shared with someone else, the empty Purse gives you
     * a place to transfer the shared cash to so you now have it
     * exclusively. 
     *
     * @see Purse#deposit
     */
    public Purse newPurse() {
        return new Purse(this);
    }
}

