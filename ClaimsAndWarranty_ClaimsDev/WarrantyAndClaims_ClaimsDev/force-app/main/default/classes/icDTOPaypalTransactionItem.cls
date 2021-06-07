/**
 * Created by Francois Poirier on 2018-12-06.
 */

public with sharing class icDTOPaypalTransactionItem {

    public icDTOPaypalAmount amount {get;set;}
    public  List<icDTOPaypalRelatedResourcesItems> related_resources {get;set;}

}