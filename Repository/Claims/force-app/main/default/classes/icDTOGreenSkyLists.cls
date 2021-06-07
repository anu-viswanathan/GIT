/**
 * Created by Andrea Pissinis on 2018-08-08.
 */

global with sharing class icDTOGreenSkyLists {

    @AuraEnabled global List<String> states {get;set;}
    @AuraEnabled global List<String> typeOfId {get;set;}
    @AuraEnabled global List<String> youAre {get;set;}


    public void setlists(List<String> states, List<String> type, List<String> youare){
        this.states = states;
        this.typeOfId = type;
        this.youAre = youAre;
    }

}