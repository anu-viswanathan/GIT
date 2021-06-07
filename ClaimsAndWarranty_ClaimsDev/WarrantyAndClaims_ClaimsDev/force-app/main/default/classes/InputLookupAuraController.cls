/*
 * Author: Enrico Murru (http://enree.co, @enreeco)
 */
public class InputLookupAuraController {

    private static String ACCOUNT = 'Account';
    private static String COMMASPACE = ', ';
    private static String COMMAOPENBRACKET = ',[';
    private static String CLOSEDBRACKET = ']';
    /*
     * Loads the initial value of the given SObject type with ID "value"
	 */
	@AuraEnabled
    public static String getCurrentValue(String type, String value){
        if(String.isBlank(type)){
            return null;
        }
        
        ID lookupId = null;
        try{   
        	lookupId = (ID)value;
        }catch(Exception e){
            return null;
        }
        
        if(String.isBlank(lookupId)){
            return null;
        }
        
        SObjectType objType = Schema.getGlobalDescribe().get(type);
        if(objType == null){
            return null;
        }

        String nameField = getSobjectNameField(objType);
        String query = 'Select Id, '+nameField+' From '+type+' Where Id = \''+lookupId+'\'';
        List<SObject> oList = Database.query(query);
        if(oList.size()==0) {
            return null;
        }
		return (String) oList[0].get(nameField);
    }
    
    /*
     * Utility class for search results
	*/
    public class SearchResult{
        public String value{get;Set;}
        public String id{get;set;}
    }
    
    /*
     * Returns the "Name" field for a given SObject (e.g. Case has CaseNumber, Account has Name)
	*/
    private static String getSobjectNameField(SobjectType sobjType){
        
        //describes lookup obj and gets its name field
        String nameField = 'Name';
        Schema.DescribeSObjectResult dfrLkp = sobjType.getDescribe();
        for(schema.SObjectField sotype : dfrLkp.fields.getMap().values()){
            Schema.DescribeFieldResult fieldDescObj = sotype.getDescribe();
            if(fieldDescObj.isNameField() ){
            	nameField = fieldDescObj.getName();
                break;
            }
        }
        return nameField;
    }
	
    /*
        Wrapper method to searchSObjectFiltered
     */
    @AuraEnabled
    public static String searchSObject(String type, String searchString){
        return InputLookupAuraController.searchSObjectFiltered(type, searchString, null);
    }
    

    /* 
         * Searchs (using SOQL) for a given Sobject type
        Mimics the searchSobjectFiltered original method, but allows a where clause to 
        be passed through to filter records based on some criteria (e.g. record type)
    */
    @AuraEnabled
    public static String searchSObjectFiltered(String type, String searchString, String whereClause){
        if(String.isBlank(type) || String.isBlank(searchString)){
            return null;
        }

        searchString        = searchString.replace('\\*', '%');
        searchString        = searchString.replace('\\', '');
        searchString        = searchString.trim();

        if(searchString.length() < 2) 
            return null;
        
        SObjectType objType = Schema.getGlobalDescribe().get(type);
        if(objType == null)
            return null;
        
        String nameField = getSobjectNameField(objType);
        String whereStmt = (!String.isBlank(whereClause)) ? ' AND ' + whereClause : '';
        String soqlQuery = '';
        if(type == ACCOUNT){
            soqlQuery = 'select BillingState, BillingCity, Owner.Name, ' + nameField + ' from ' + type + ' where ' + nameField + ' like \'%' + String.escapeSingleQuotes(searchString) +'%\' ' + whereStmt + ' LIMIT 50000';
        }
        else{
            soqlQuery = 'select Id, ' + nameField + ' from ' + type + ' where ' + nameField + ' like \'%' + String.escapeSingleQuotes(searchString) +'%\' ' + whereStmt+' LIMIT 500';
			// 2020-04-28 Original query was this
            // soqlQuery = 'select Id, ' + nameField + ' from ' + type + ' where ' + nameField + ' like \'%' + String.escapeSingleQuotes(searchString) +'%\' ' + whereStmt+' LIMIT 50000';
        }

        List<Sobject> results   = Database.query(soqlQuery);

        List<SearchResult> output = new List<SearchResult>();
        for(SObject sobj : results){
            SearchResult sr = new SearchResult();
            sr.id = (String)sobj.get('Id');
            sr.value = (String)sobj.get(nameField);

            if(type == ACCOUNT){
                String billingCity = (String)sobj.get('BillingCity');
                String billingState = (String) sobj.get('BillingState');
                String ownerName = (String) sobj.getSObject('Owner').get('Name');

                if(billingCity != NULL){
                    sr.value  = sr.value + COMMASPACE + billingCity;
                }if(billingState != NULL){
                    sr.value  = sr.value + COMMASPACE + billingState;
                }if(ownerName != NULL){
                    sr.value  = sr.value + COMMAOPENBRACKET + ownerName + CLOSEDBRACKET;
                }
            }
            output.add(sr)   ;
        }
        return JSON.serialize(output);
    }



      
}