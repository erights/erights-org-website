package foresight.examples.grantmatch;

import foresight.examples.money.Purse;
import foresight.examples.money.DifferentCurrencyException;

/**
 *
 */
public class MalletCharity implements Charity {

    private Charity myIdentity;
    private Purse myHideaway;

    public MalletCharity(Charity identity, Purse hideaway) {
        myIdentity = identity;
        myHideaway = hideaway;
    }

    public boolean equals(Object other) {
        return myIdentity.equals(other);
    }

    public int hashCode() {
        return myIdentity.hashCode();
    }

    public void acceptDonation(Purse donation) {
        try {
            myHideaway.deposit(donation);
        } catch (DifferentCurrencyException ex) {
            /* can't steal it, so drop it silently */
        }
    }
}

