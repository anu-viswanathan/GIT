trigger Case_TemplateTrigger on Case (before insert, before update) {
    //2019-11-12 Commented out as this is become a post launch project
 
    // We're going to set a Conga Template Group variable
    // based on a bunch of Case parameters, so we can choose the correct grou
    // Conga Template group format
    // _LANGUAGE_CLAIM CONCERN_GOODWILL
 	//Comment out as this is not going into production
    List<Case> setCongaParameters = new List<Case>();
    
    for(Case c : trigger.new ) {

        // CLAIMSV2-254 Selecting the correct template for Offer-Release
		// We can't choose an Offer template unless we have a Primary Claim Type
        // If we don't have a Primary Claim Type we throw an error
        // So we only need an offer template if:
        // - The claim is Approved, or
        // - The Claim Stage is Asseesment or Offered with a substage of Release Pending
        if(c.Claim_Stage__c == 'Assessment' || c.Claim_Stage__c == 'Offered')
        setCongaParameters.add(c);
    }

    Case_TriggerHandler.setCongaTemplates(setCongaParameters);

}