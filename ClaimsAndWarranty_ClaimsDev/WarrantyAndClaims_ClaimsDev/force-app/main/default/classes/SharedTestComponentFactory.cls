/**
 * Created by Gerard van Kempen on 2019-12-19.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

@IsTest
public class SharedTestComponentFactory {
    public class AccountTestingTuple {
        public final Account referenceAccount;
        public Account workingAccount;
        public AccountTestingTuple(Account testAccount) {
            this.referenceAccount = testAccount.clone();
            this.workingAccount = testAccount.clone();
        }
    }

    private static String newRandomString(Integer length) {
        Blob blobKey = Crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,length);
    }

    public static AccountTestingTuple newAccountTestingTuple() {
        Account acct = new Account();
        acct.CurrencyIsoCode = 'EUR';
        acct.Name = 'Testing Account - ' + newRandomString(8);
//        acct.Owner = '';
        return new AccountTestingTuple(acct);
    }
}