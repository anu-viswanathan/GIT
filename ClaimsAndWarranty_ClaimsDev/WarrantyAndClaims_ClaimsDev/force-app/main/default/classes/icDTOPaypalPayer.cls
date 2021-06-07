/**
 * Created by Francois Poirier on 2018-12-06.
 */

public with sharing class icDTOPaypalPayer {

    public String payment_method {get;set;}
    public String status {get;set;}
    public icDTOPaypalPayerInfo payer_info {get;set;}

}