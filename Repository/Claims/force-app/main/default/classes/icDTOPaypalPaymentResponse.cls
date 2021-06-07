/**
 * Created by Francois Poirier on 2018-12-06.
 */

public with sharing class icDTOPaypalPaymentResponse {

    public String id {get;set;}
    public String intent {get;set;}
    public String state {get;set;}
    public String cart {get;set;}
    public String create_time {get;set;}
    public icDTOPaypalPayer payer {get;set;}
    public List<icDTOPaypalTransactionItem> transactions {get;set;}

}