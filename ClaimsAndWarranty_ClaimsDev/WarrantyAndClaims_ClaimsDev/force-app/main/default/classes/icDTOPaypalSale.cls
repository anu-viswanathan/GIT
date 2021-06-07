/**
 * Created by Francois Poirier on 2018-12-05.
 */

public with sharing class icDTOPaypalSale {

    public String id {get;set;}
    public String saleState {get;set;}
    public String payment_mode {get;set;}
    public String protection_eligibility {get;set;}
    public String parent_payment {get;set;}
    public String create_time {get;set;}
    public String update_time {get;set;}
    public icDTOPaypalAmount amount {get;set;}

}