package foresight.examples.money;

import java.math.BigInteger;

/**
 * Each currency is represented by a unique Currency object and a
 * unique Mint object.  The Currency object is only descriptive--it's
 * object identity represents the unique identity of the currency.
 * The Currency object itself does not grant any authority.  In
 * contrast, the holder of the Mint is able to manufacture more cash
 * in that currency, or "print money".
 *
 * @see Currency
 */
public class Mint {

    private Currency myCurrency = new Currency();

    /**
     * Anyone may create a new currency.  The creator starts with
     * exclusive access to the Mint for that currency.
     */
    public Mint() {}

    /**
     * The Currency object that represents the identity of this currency.
     */
    public Currency currency() {
    return myCurrency;
    }

    /**
     * Only the holder of a Mint can create new cash in that
     * currency.  The Mint holder can hand out Purses containing this
     * new cash without giving anyone else access to the Mint.  This
     * is the only way cash goes into circulation.
     *
     * @exception NegativeBalanceException If 'balance' is negative
     */
    public Purse inflate(BigInteger balance) throws NegativeBalanceException {
        return new Purse(myCurrency, balance);
    }
}

