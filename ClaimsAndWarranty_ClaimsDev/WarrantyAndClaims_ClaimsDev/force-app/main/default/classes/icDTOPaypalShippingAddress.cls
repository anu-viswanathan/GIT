/**
 * Created by Francois Poirier on 2018-12-06.
 */

public with sharing class icDTOPaypalShippingAddress {

    public String recipient_name {get;set;}
    public String line1 {get;set;}
    public String city {get;set;}
    public String state {get;set;}
    public String postal_code {get;set;}
    public String country_code {get;set;}
    
}