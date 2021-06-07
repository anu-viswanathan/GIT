/**
 * Created by Francois Poirier on 2018-12-06.
 */

public with sharing class icDTOPaypalPayerInfo {

    public String email {get;set;}
    public String phone {get;set;}
    public String first_name {get;set;}
    public String last_name {get;set;}
    public String payer_id {get;set;}
    public String country_code {get;set;}
    public icDTOPaypalShippingAddress shipping_address {get;set;}

}