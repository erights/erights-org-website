package foresight.examples.money;

/**
 * Thrown if a transfer is attempted between Purses holding cash
 * denominated different currencies.
 */
public class DifferentCurrencyException extends Exception {
    public DifferentCurrencyException() {}
    public DifferentCurrencyException(String s) { super(s); }
}
