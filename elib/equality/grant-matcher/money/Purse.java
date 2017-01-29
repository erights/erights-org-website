package foresight.examples.money;

import java.math.BigInteger;

/**
 * Cash is represented internally as counters in Purse objects, so the
 * money system can ensure they are manipulated properly. 
 */
public class Purse {

    private Currency myCurrency;
    private BigInteger myBalance;

    /**
     *
     */
    /*package*/ Purse(Currency currency, BigInteger balance)
         throws NegativeBalanceException {

        if (balance.signum() < 0) {
            throw new NegativeBalanceException
                ("initial balance must be positive");
        }
        myCurrency = currency;
        myBalance = balance;
    }

    /**
     *
     */
    /*package*/ Purse(Currency currency) {

        myCurrency = currency;
        myBalance = BigInteger.valueOf(0);
    }

    /**
     * This Purse can only hold cash in this currency.
     */
    public Currency currency() {
        return myCurrency;
    }

    /**
     * How many units of cash are held in this Purse at the moment?
     */
    public BigInteger balance() {
        return myBalance;
    }

    /**
     * Take all the cash from that Purse and put it in this one.  A
     * typical use is a method that performs a service in exchage
     * for payment: <p>
     * <pre>
     *     public Whatever performService(Arg arg, Purse payment)
     *          throws DifferentCurrencyException {
     * <p>
     *         if (myPurse.deposit(payment) < myFee) {
     *             //deal with underpayment
     *         } else {
     *             //perform service
     *         }
     *     }
     * </pre>
     *
     * @return The amount transfered. 
     * @exception DifferentCurrencyException If the other Purse is
     * for a different currency.
     */
    public BigInteger deposit(Purse other) throws DifferentCurrencyException {
        if (myCurrency != other.myCurrency) {
            throw new DifferentCurrencyException();
        }
        synchronized (myCurrency.myLock) {
            BigInteger result = other.myBalance;
            other.myBalance = BigInteger.valueOf(0);
            myBalance = myBalance.add(result);
            return result;
        }
    }

    /**
     * A convenient wrapper of 'withdraw(BigInteger)'
     */
    public Purse withdraw(long amount) throws NegativeBalanceException {
        return withdraw(BigInteger.valueOf(amount));
    }

    /**
     * Create a new Purse, and transfer this amount of the money in
     * this Purse to that one.  A typical use is to create a Purse to
     * convey a cash payment to someone else.  <p>
     * <pre>
     *     subcontractor.performService(myPurse.withdraw(fee));
     * </pre><p>
     *
     * It is up to the payee to move the money out of this Purse in
     * order for the payor to lose access to it.
     *
     * @return The new Purse.
     * @exception NegativeBalanceException If the amount is
     * negative, since the returned Purse would have had a negative
     * balance. <p>
     * 
     * If the amount is greater than the balance of this
     * Purse, since this Purse would be left with a negative balance.
     */
    public Purse withdraw(BigInteger amount) throws NegativeBalanceException {
        synchronized (myCurrency.myLock) {
            if (amount.signum() < 0) {
                throw new NegativeBalanceException
                    ("cannot withdraw a negative amount");
            } else if (amount.compareTo(myBalance) > 0) {
                throw new NegativeBalanceException
                    ("balance would become negative");
            }
            myBalance = myBalance.subtract(amount);
            return new Purse(myCurrency, amount);
        }
    }
}
