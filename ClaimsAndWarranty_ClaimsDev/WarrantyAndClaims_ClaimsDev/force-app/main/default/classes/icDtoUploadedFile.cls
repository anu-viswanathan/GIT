/**
 * Created by Francois Poirier on 2019-11-20.
 */

global with sharing class icDtoUploadedFile {

    @AuraEnabled global String DocumentId {get;set;}
    @AuraEnabled global String name {get;set;}

}