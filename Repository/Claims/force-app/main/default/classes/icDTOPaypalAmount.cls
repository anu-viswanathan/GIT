/**
 * Created by Francois Poirier on 2018-12-05.
 */

public with sharing class icDTOPaypalAmount {

    public String total {get;set;}
    public String paymentcurrency {get;set;}
    public icDTOPaypalAmoutDetail details {get;set;}

}