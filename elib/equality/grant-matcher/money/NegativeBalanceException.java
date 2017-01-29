package foresight.examples.money;

/**
 * Thrown if an action is taken that would result in a negative
 * cash balance. 
 */
public class NegativeBalanceException extends Exception {
    public NegativeBalanceException() {}
    public NegativeBalanceException(String s) { super(s); }
}
