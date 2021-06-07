/**
 * Created by Francois Poirier on 2019-11-18.
 */

public with sharing class icUtilSchema implements icIClass {

    public Object GetInstance(){

        return new Impl();
    }

    public interface IClass {

        List<icDTOpickList> getPickListValues(String objectApiName, String fieldApiName);
    }

    public class Impl implements IClass {

        public List<icDTOpickList> getPickListValues(String objectApiName, String fieldApiName){

            List<icDTOpickList> lstPickvals=new List<icDTOpickList>();

            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectApiName);//From the Object Api name retrieving the SObject
            Sobject mySobject = sObjectType.newSObject();
            Schema.sObjectType sobject_type = mySobject.getSObjectType(); //grab the sobject that was passed
            Schema.DescribeSObjectResult sobjectDescribe = sobject_type.getDescribe(); //describe the sobject

            Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap(); //get a map of fields for the passed sobject

            List<Schema.PicklistEntry> pickListValues = fieldMap.get(fieldApiName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject

            icDTOpickList emptyElement = new icDTOpickList();
            lstPickvals.add(emptyElement);
            system.debug('picklistvalues ===> ' + pickListValues);
            for (Schema.PicklistEntry a : pickListValues)
            {
                icDTOpickList pl = new icDTOpickList();
                pl.label = a.getLabel();
                pl.value = a.getValue();
                pl.isActive = a.isActive();
                pl.isDefault = a.isDefaultValue();
                pl.isSelected = false;

                lstPickvals.add(pl);
            }

            return lstPickvals;
        }
    }
}