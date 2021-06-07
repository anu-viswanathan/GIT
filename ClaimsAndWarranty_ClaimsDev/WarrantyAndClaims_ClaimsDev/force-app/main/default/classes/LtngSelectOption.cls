/*
	Used for picklist options in Lightning Experience / Lightning components
*/public with sharing class LtngSelectOption {
    @AuraEnabled 
    public String label   { get; set; }
    @AuraEnabled
    public String value   { get; set; }

	public LtngSelectOption(String v, String l) {
    	this.value 			= v;
    	this.label 			= l;
		
	}


}