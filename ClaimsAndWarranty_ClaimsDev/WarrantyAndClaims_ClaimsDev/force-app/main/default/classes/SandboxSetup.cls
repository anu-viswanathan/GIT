public class SandboxSetup {
// giddy up
    // Creates a bunch of Sample data for sanboxes. Can be called manually, or not.
    
    public static void sandboxSetup() {
    
    // Create some leads    
    List<Lead> leads = New List<Lead>();

	// A couple of IKO Roofpro Leads        
    Lead luke = new Lead();
        luke.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('IKO ROOFPRO Lead').getRecordTypeId();
        luke.FirstName = 'Luke';
        luke.LastName = 'Skywalker';
        luke.Company = 'Rebel Alliance';
        luke.Email = 'luke.skywalker@imperialforces.com';
        luke.Phone = '8002524587';
        luke.LeadSource = 'Other';
    leads.add(luke);

    Lead leia = new Lead();
        leia.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('IKO ROOFPRO Lead').getRecordTypeId();
        leia.FirstName = 'Leia';
        leia.LastName = 'Skywalker';
        leia.Company = 'Rebel Alliance';
        leia.Email = 'leia.skywalker@imperialforces.com';
        leia.Phone = '8002524587';
        leia.LeadSource = 'Other';
    leads.add(leia);

Lead darth = new Lead();
        darth.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('IKO ROOFPRO Lead').getRecordTypeId();
        darth.FirstName = 'Darth';
        darth.LastName = 'Vader';
        darth.Company = 'Imperial Forces';
        darth.Email = 'darth.skywalker@imperialforces.com';
        darth.Phone = '8002524587';
        darth.LeadSource = 'Other';
    leads.add(darth);

    Lead emperor = new Lead();
        emperor.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('IKO ROOFPRO Lead').getRecordTypeId();
        emperor.FirstName = 'Emperor';
        emperor.LastName = 'Emperor';
        emperor.Company = 'Imperial Forces';
        emperor.Email = 'darth.skywalker@imperialforces.com';
        emperor.Phone = '8002524587';
        emperor.LeadSource = 'Other';
    leads.add(emperor);

        
// insert leads;
        
List<Account> accounts = new List<Account>();
        
Account cntower = new Account();
        cntower.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        cntower.Name = 'CN Tower';
        cntower.BillingStreet = '';
        cntower.BillingCity = 'Toronto';
        cntower.BillingStateCode = 'ON';
        cntower.BillingCountryCode = 'CA';
     accounts.add(cntower);
        
Account whitehouse = new Account();
        whitehouse.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        whitehouse.Name = 'White House';
        whitehouse.BillingStreet = '1600 Pennsylvania Avenue';
        whitehouse.BillingCity = 'Washington';
        whitehouse.BillingStateCode = 'DC';
        whitehouse.BillingCountryCode = 'US';
        whitehouse.Address_Verification_Status__c = 'Verified';
     accounts.add(whitehouse);
        
Account louvre = new Account();
        louvre.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        louvre.Name = 'Louvre Museum';
        louvre.BillingStreet = 'Rue de Rivoli';
        louvre.BillingCity = 'Paris';
        louvre.BillingStateCode = 'DC';
        louvre.BillingCountryCode = 'US';
        louvre.Address_Verification_Status__c = 'Verified';
     accounts.add(louvre);

Account spaceneedle = new Account();
        spaceneedle.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        spaceneedle.Name = 'Space Needle';
        spaceneedle.BillingStreet = '400 Broad Street';
        spaceneedle.BillingCity = 'Seattle';
        spaceneedle.BillingStateCode = 'WA';
        spaceneedle.BillingPostalCode = '98109';
        spaceneedle.BillingCountryCode = 'US';
        spaceneedle.BillingCountry = 'United States';
        spaceneedle.Address_Verification_Status__c = 'Verified';
     accounts.add(spaceneedle);

Account yankee = new Account();
        yankee.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        yankee.Name = 'Yankee Stadium';
        yankee.BillingStreet = '1 E 161 St';
        yankee.BillingCity = 'New York';
        yankee.BillingStateCode = 'NY';
        yankee.BillingPostalCode = '10451';
        yankee.BillingCountryCode = 'US';
        yankee.BillingCountry = 'United States';
        yankee.Address_Verification_Status__c = 'Verified';
     accounts.add(yankee);
        

Account ago = new Account();
        ago.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        ago.Name = 'Art Gallery of Ontario';
        ago.BillingStreet = '317 Dundas Street West';
        ago.BillingCity = 'Toronto';
        ago.BillingStateCode = 'ON';
        ago.BillingPostalCode = 'M5T 1G4';
        ago.BillingCountryCode = 'CA';
        ago.BillingCountry = 'Canada';
        ago.Address_Verification_Status__c = 'Verified';
     accounts.add(ago);

Account rom = new Account();
        rom.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        rom.Name = 'Royal Ontario Museum';
        rom.BillingStreet = '100 Queens Park';
        rom.BillingCity = 'Toronto';
        rom.BillingStateCode = 'ON';
        rom.BillingPostalCode = 'M5S 2C6';
        rom.BillingCountryCode = 'CA';
        rom.BillingCountry = 'Canada';
        rom.Address_Verification_Status__c = 'Verified';
     accounts.add(rom);

        
Account bradbury = new Account();
        bradbury.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        bradbury.Name = 'Bradbury Building';
        bradbury.BillingStreet = '304 S Broadway';
        bradbury.BillingCity = 'Los Angeles';
        bradbury.BillingStateCode = 'CA';
        bradbury.BillingPostalCode = '90013';
        bradbury.BillingCountryCode = 'US';
        bradbury.BillingCountry = 'United States';
        bradbury.Address_Verification_Status__c = 'Verified';
     accounts.add(bradbury);

Account nypl = new Account();
        nypl.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        nypl.Name = 'New York Public Library';
        nypl.BillingStreet = '476 5th Ave';
        nypl.BillingCity = 'New York';
        nypl.BillingStateCode = 'NY';
        nypl.BillingPostalCode = '10018';
        nypl.BillingCountryCode = 'US';
		nypl.Address_Verification_Status__c = 'Verified';
     accounts.add(nypl);

Account empireState = new Account();
        empireState.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        empireState.Name = 'Empire State Building';
        empireState.BillingStreet = '20 W 34th Street';
        empireState.BillingCity = 'New York';
        empireState.BillingStateCode = 'NY';
        empireState.BillingPostalCode = '10001';
        empireState.BillingCountryCode = 'US';
		empireState.Address_Verification_Status__c = 'Verified';
     accounts.add(empireState);

Account gracieMansion = new Account();
        gracieMansion.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        gracieMansion.Name = 'Gracie Mansion';
        gracieMansion.BillingStreet = 'East End Avenue';
        gracieMansion.BillingCity = 'New York';
        gracieMansion.BillingStateCode = 'NY';
        gracieMansion.BillingPostalCode = '10028';
        gracieMansion.BillingCountryCode = 'US';
		gracieMansion.Address_Verification_Status__c = 'Verified';
     accounts.add(gracieMansion);

Account windsorCastle = new Account();
        windsorCastle.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        windsorCastle.Name = 'Windsor Castle';
        windsorCastle.BillingStreet = '';
        windsorCastle.BillingCity = 'Windsor';
        windsorCastle.BillingPostalCode = 'SL4 1NJ';
        windsorCastle.BillingCountryCode = 'GB';
		windsorCastle.Address_Verification_Status__c = 'Verified';
     accounts.add(windsorCastle);

Account sydneyOpera = new Account();
        sydneyOpera.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        sydneyOpera.Name = 'Sydney Opera House';
        sydneyOpera.BillingStreet = 'Bennelong Point';
        sydneyOpera.BillingCity = 'Sydney';
        sydneyOpera.BillingStateCode = 'NSW';
        sydneyOpera.BillingPostalCode = '2000';
        sydneyOpera.BillingCountryCode = 'AU';
		sydneyOpera.Address_Verification_Status__c = 'Verified';
     accounts.add(sydneyOpera);

        
Account schwartzDeli = new Account();
        schwartzDeli.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        schwartzDeli.Name = 'Schwartz\'s Deli';
        schwartzDeli.BillingStreet = '3895 St Laurent Blvd';
        schwartzDeli.BillingCity = 'Montreal';
        schwartzDeli.BillingStateCode = 'QC';
        schwartzDeli.BillingPostalCode = 'H2W 1X9';
        schwartzDeli.BillingCountryCode = 'CA';
		schwartzDeli.Address_Verification_Status__c = 'Verified';
     accounts.add(schwartzDeli);
        
Account torontoCityHall = new Account();
        torontoCityHall.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        torontoCityHall.Name = 'Toronto City Hall';
        torontoCityHall.BillingStreet = '100 Queen St W';
        torontoCityHall.BillingCity = 'Toronto';
        torontoCityHall.BillingStateCode = 'ON';
        torontoCityHall.BillingPostalCode = 'M5H 2N2';
        torontoCityHall.BillingCountryCode = 'CA';
		torontoCityHall.Address_Verification_Status__c = 'Verified';
     accounts.add(torontoCityHall);

Account theSimpsons = new Account();
        theSimpsons.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        theSimpsons.Name = 'The Simpsons';
        theSimpsons.BillingStreet = '724 Evergreen Terrace';
        theSimpsons.BillingCity = 'Springfield';
        theSimpsons.BillingStateCode = 'NY';
        theSimpsons.BillingPostalCode = '49007';
        theSimpsons.BillingCountryCode = 'US';
		theSimpsons.Phone = '4162983738';
        theSimpsons.Address_Verification_Status__c = 'Verified';
	accounts.add(theSimpsons);

Account fallingwater = new Account();
        fallingwater.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        fallingwater.Name = 'Fallingwater';
        fallingwater.BillingStreet = '1491 Mill Run Road';
        fallingwater.BillingCity = 'Mill Run';
        fallingwater.BillingStateCode = 'PA';
        fallingwater.BillingPostalCode = '16464';
        fallingwater.BillingCountryCode = 'US';
		fallingwater.Phone = '4162983738';
        fallingwater.Address_Verification_Status__c = 'Verified';
	accounts.add(fallingwater);

Account quebecNA = new Account();
        quebecNA.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        quebecNA.Name = 'Quebec National Assembly';
        quebecNA.BillingStreet = '1045, rue des Parlementaires';
        quebecNA.BillingCity = 'Quebec';
        quebecNA.BillingStateCode = 'QC';
        quebecNA.BillingPostalCode = 'G1A 1A3';
        quebecNA.BillingCountryCode = 'CA';
		quebecNA.Phone = '4162983738';
        quebecNA.Address_Verification_Status__c = 'Verified';
	accounts.add(quebecNA);

Account guggenheim = new Account();
        guggenheim.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        guggenheim.Name = 'Guggenheim';
        guggenheim.BillingStreet = '1071 5th Avenue';
        guggenheim.BillingCity = 'New York';
        guggenheim.BillingStateCode = 'NY';
        guggenheim.BillingPostalCode = '10128';
        guggenheim.BillingCountryCode = 'US';
		guggenheim.Phone = '2124233500';
        guggenheim.Address_Verification_Status__c = 'Verified';
	accounts.add(guggenheim);

// this should be in spain, but we probably don't support it. Change this if you can.
Account bilbao = new Account();
        bilbao.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        bilbao.Name = 'Guggenheim Bilbao';
        bilbao.BillingStreet = 'Abandoibarra Etorb., 2';
        bilbao.BillingCity = 'Bilbo, Bizkaia';
        bilbao.BillingStateCode = 'NY';
        bilbao.BillingPostalCode = '48009';
        bilbao.BillingCountryCode = 'US';
		bilbao.Phone = '2124233500';
        bilbao.Address_Verification_Status__c = 'Verified';
	accounts.add(bilbao);

        
// I need accounts that have GPS data in them, so that we can test our GPS data classes
// Accounts need to have a value in the YTD_Dollars__c field
// They also need a value in the Mapics_ERP_ID__c field

Account bigCustomer = new Account();
        bigCustomer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        bigCustomer.Name = 'Big US Distributor';
        bigCustomer.BillingStreet = '3700 W Irving St';
        bigCustomer.BillingCity = 'Wichita';
        bigCustomer.BillingStateCode = 'KS';
        bigCustomer.BillingPostalCode = '67213';
        bigCustomer.BillingCountryCode = 'US';
        bigCustomer.YTD_Dollars__c = 1000000;
        bigCustomer.Mapics_ERP_Id__c = '52476981';
     accounts.add(bigCustomer);

Account cdnCustomer = new Account();
        cdnCustomer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        cdnCustomer.Name = 'Big CDN Distributor';
        cdnCustomer.BillingStreet = '600 Pembina Hwy';
        cdnCustomer.BillingCity = 'Winnipeg';
        cdnCustomer.BillingStateCode = 'MB';
        cdnCustomer.BillingPostalCode = 'R3M 2M5';
        cdnCustomer.BillingCountryCode = 'CA';
        cdnCustomer.YTD_Dollars__c = 1;
        cdnCustomer.Mapics_ERP_Id__c = '52476982';
     accounts.add(cdnCustomer);
        
// Create a duplicate to merge so we can test our duplicate merge code
Account duplicateMaster = new Account();
        duplicateMaster.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        duplicateMaster.Name = 'Duplicate';
     accounts.add(duplicateMaster);
        
Account duplicateSlave = new Account();
        duplicateSlave.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        duplicateSlave.Name = 'Duplicate';
     accounts.add(duplicateSlave);

// Create an Artchitect, which is actually a Designer. For some reason
Account frank = new Account();
        frank.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Designer').getRecordTypeId();
        frank.Name = 'Frank Lloyd Wright';
        frank.BillingStreet = '1491 Mill Run Road';
        frank.BillingCity = 'Mill Run';
        frank.BillingStateCode = 'PA';
        frank.BillingPostalCode = '16464';
        frank.BillingCountryCode = 'US';
		frank.Phone = '4162983738';
	accounts.add(frank);

Account gehryPartners = new Account();
        gehryPartners.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Designer').getRecordTypeId();
        gehryPartners.Name = 'Gehry Partners, LLP';
        gehryPartners.BillingStreet = '12541 Beatrice Street';
        gehryPartners.BillingCity = 'Los Angeles';
        gehryPartners.BillingStateCode = 'CA';
        gehryPartners.BillingPostalCode = '90066';
        gehryPartners.BillingCountryCode = 'US';
		gehryPartners.Phone = '4162983738';
	accounts.add(gehryPartners);

Account mies = new Account();
        mies.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Designer').getRecordTypeId();
        mies.Name = 'Ludwig Mies van der Rohe';
        mies.BillingStreet = '66 Wellington Street West';
        mies.BillingCity = 'Toronto';
        mies.BillingStateCode = 'ON';
        mies.BillingPostalCode = 'M5K 1A1';
        mies.BillingCountryCode = 'CA';
		mies.Phone = '4162983738';
	accounts.add(mies);

Account zaha = new Account();
        zaha.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Designer').getRecordTypeId();
        zaha.Name = 'Zaha Hadid Architects';
        zaha.BillingStreet = '10 Bowling Green Lane';
        zaha.BillingCity = 'London';
        zaha.BillingStateCode = '';
        zaha.BillingPostalCode = 'EC1R 0BQ';
        zaha.BillingCountryCode = 'GB';
		zaha.Phone = '+442072535147';
	accounts.add(zaha);

        
insert accounts;

List<Contact> dudesToAdd = new List<Contact>();        

	Contact frankLloyd = new Contact();
        frankLloyd.FirstName = 'Frank Lloyd';
        frankLloyd.LastName = 'Wright';
        frankLloyd.AccountId = frank.Id;
	dudesToAdd.add(frankLloyd);

	Contact frankGehry = new Contact();
        frankGehry.FirstName = 'Frank';
        frankGehry.LastName = 'Gehry';
        frankGehry.AccountId = gehryPartners.Id;
	dudesToAdd.add(frankGehry);

    Contact deckard = new Contact();
        deckard.FirstName = 'Rick';
        deckard.LastName = 'Deckard';
        deckard.AccountId = bradbury.Id;
	dudesToAdd.add(deckard);
        
insert dudesToAdd;
        
To_Merge__c mergeThings = new To_Merge__c();
        mergeThings.Master__c = duplicateMaster.Id;
        mergeThings.Duplicates__c = duplicateSlave.Id;
insert mergeThings;

// Create some sample products, because we'll need them for things like Cases, Warranties etc.

list<Product2> testProducts = new list<Product2>();
	
	Product2 organicShingle = new Product2();
        organicShingle.Name = 'Organic Shingle 1';
        organicShingle.Colour__c = 'Black';
		organicShingle.ProductCode = 'ORG-SHINGLE';
        organicShingle.IsActive = true;
        organicShingle.Is_Legacy__c = false;
        organicShingle.Sectors__c = 'CA;US;Commercial;Blair;Hyload';
    	testProducts.add(organicShingle);

	Product2 glassShingle = new Product2();
        glassShingle.Name = 'Glass Shingle 1';
        glassShingle.Colour__c = 'Black';
		glassShingle.ProductCode = 'GLS-SHINGLE';
        glassShingle.IsActive = true;
        glassShingle.Is_Legacy__c = false;
        glassShingle.Sectors__c = 'CA;US;Commercial;Blair;Hyload';
    	testProducts.add(glassShingle);

insert testProducts;
        
        
// I need orders on the bigCustomer and cdnCustomer accounts to provide
// full test coverage. So that's fun.
// 
list<Order> orders = new List<Order>();
    
    Order bigCustomerOrder1 = new Order();
        bigCustomerOrder1.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Shipping Summary').getRecordTypeId();
      	bigCustomerOrder1.AccountId = bigCustomer.Id;
        bigCustomerOrder1.Company_Number_Mapics__c = bigCustomer.Mapics_ERP_ID__c;
        bigCustomerOrder1.Amount_Mapics__c = 900;
        bigCustomerOrder1.Currency_MAPICS__c = 'USD';
        bigCustomerOrder1.Customer_Name_Mapics__c = 'Big US Customer';
        bigCustomerOrder1.Customer_Number_Mapics__c = bigCustomer.Mapics_ERP_ID__c;
        bigCustomerOrder1.MAPICS_Product_ID__c = 'SHN-BLK-73';
        bigCustomerOrder1.Sales_Rep_Name_MAPICS__c = 'Anakin Skywalker';
        bigCustomerOrder1.Shipped_Quantity_MAPICS__c = 153.247;
        bigCustomerOrder1.Squares_MAPICS__c = 2.578;
        bigCustomerOrder1.EffectiveDate = System.Today();
        bigCustomerOrder1.Status = 'Draft';
    orders.add(bigCustomerOrder1);    

    // Order in current year previous month    
    Order bigCustomerOrder2 = new Order();
        bigCustomerOrder2.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Shipping Summary').getRecordTypeId();
      	bigCustomerOrder2.AccountId = bigCustomer.Id;
        bigCustomerOrder2.Company_Number_Mapics__c = bigCustomer.Mapics_ERP_ID__c;
        bigCustomerOrder2.Amount_Mapics__c = 900;
        bigCustomerOrder2.Currency_MAPICS__c = 'USD';
        bigCustomerOrder2.Customer_Name_Mapics__c = 'Big US Customer';
        bigCustomerOrder2.Customer_Number_Mapics__c = bigCustomer.Mapics_ERP_ID__c;
        bigCustomerOrder2.MAPICS_Product_ID__c = 'SHN-BLK-73';
        bigCustomerOrder2.Sales_Rep_Name_MAPICS__c = 'Anakin Skywalker';
        bigCustomerOrder2.Shipped_Quantity_MAPICS__c = 9153.247;
        bigCustomerOrder2.Squares_MAPICS__c = 22.578;
        bigCustomerOrder2.Unit_of_Measure__c = 'BD';
        bigCustomerOrder2.EffectiveDate = System.Today().addMonths(-1);
        bigCustomerOrder2.Status = 'Draft';
    orders.add(bigCustomerOrder2);    

    // order in previous year YTD period AND previous year previous month
    Order bigCustomerOrder3 = new Order();
        bigCustomerOrder3.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Shipping Summary').getRecordTypeId();
      	bigCustomerOrder3.AccountId = bigCustomer.Id;
        bigCustomerOrder3.Company_Number_Mapics__c = bigCustomer.Mapics_ERP_ID__c;
        bigCustomerOrder3.Amount_Mapics__c = 900;
        bigCustomerOrder3.Currency_MAPICS__c = 'USD';
        bigCustomerOrder3.Customer_Name_Mapics__c = 'Big US Customer';
        bigCustomerOrder3.Customer_Number_Mapics__c = bigCustomer.Mapics_ERP_ID__c;
        bigCustomerOrder3.MAPICS_Product_ID__c = 'SHN-BLK-73';
        bigCustomerOrder3.Product_Name__c = 'Shingles, Black, Not Stirred';
        bigCustomerOrder3.Sales_Rep_Name_MAPICS__c = 'Anakin Skywalker';
        bigCustomerOrder3.Shipped_Quantity_MAPICS__c = 9153.247;
        bigCustomerOrder3.Squares_MAPICS__c = 22.578;
        bigCustomerOrder3.Unit_of_Measure__c = 'BD';
        bigCustomerOrder3.EffectiveDate = System.Today().addYears(-1).addMonths(-1);
        bigCustomerOrder3.Status = 'Draft';
    orders.add(bigCustomerOrder3);    

    // order in previous year but NOT year to date
    Order bigCustomerOrder4 = new Order();
      	bigCustomerOrder4.AccountId = bigCustomer.Id;
        bigCustomerOrder4.Company_Number_Mapics__c = bigCustomer.Mapics_ERP_ID__c;
        bigCustomerOrder4.Amount_Mapics__c = 900;
        bigCustomerOrder4.Currency_MAPICS__c = 'USD';
        bigCustomerOrder4.Customer_Name_Mapics__c = 'Big US Customer';
        bigCustomerOrder4.Customer_Number_Mapics__c = bigCustomer.Mapics_ERP_ID__c;
        bigCustomerOrder4.MAPICS_Product_ID__c = 'SHN-BLK-73';
        bigCustomerOrder4.Product_Name__c = 'Shingles, Orange, Because Orange';
        bigCustomerOrder4.Sales_Rep_Name_MAPICS__c = 'Anakin Skywalker';
        bigCustomerOrder4.Shipped_Quantity_MAPICS__c = 9153.247;
        bigCustomerOrder4.Squares_MAPICS__c = 22.578;
        bigCustomerOrder4.Unit_of_Measure__c = 'BD';
        bigCustomerOrder4.EffectiveDate = System.Today().addYears(-1).addMonths(+1);
        bigCustomerOrder4.Status = 'Draft';
    orders.add(bigCustomerOrder4);    

        
insert orders;
        
/* Create some Claims cases which will also need Claim Types assocated with them. */
list<Case> claims = new List<Case>();
list<Claim_Type__c> claimTypes = new list<Claim_Type__c>();
    
Case comClaim = new Case();
        comClaim.Description = 'Commercial Claim created by Test Case';
        comClaim.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        comClaim.Sector__c = 'US';
        comClaim.AccountId = yankee.Id;
        comClaim.Distributor__c = bigCustomer.Id;
        comClaim.ContactId = deckard.Id;
        claims.add(comClaim);

Case orgClaim = new Case();
        orgClaim.Description = 'Organic Residential Claim';
        orgClaim.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
        orgClaim.Sector__c = 'CA';
        orgClaim.AccountId = ago.Id;
        orgClaim.Distributor__c = bigCustomer.Id;
        orgClaim.ContactId = frankLloyd.Id;
        orgClaim.Product__c = organicShingle.Id;
        orgClaim.Replacement_Product__c = glassShingle.Id;
        orgClaim.Preferred_Language__c = 'English';
        claims.add(orgClaim);


Case quebecClaim = new Case();
        quebecClaim.Description = 'Organic Residential Claim created by Test Case';
        quebecClaim.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
        quebecClaim.Sector__c = 'CA';
        quebecClaim.AccountId = quebecNA.Id;
        quebecClaim.Distributor__c = bigCustomer.Id;
        quebecClaim.ContactId = frankLloyd.Id;
        quebecClaim.Product__c = glassShingle.Id;
        quebecClaim.Replacement_Product__c = glassShingle.Id;
        quebecClaim.Preferred_Language__c = 'English';
        quebecClaim.Origin = 'Owner';
        claims.add(quebecClaim);

// Quebec french and we're going to add a claim type of J
Case quebecClaimFrench = new Case();
        quebecClaimFrench.Description = 'Organic Residential Claim created by Test Case';
        quebecClaimFrench.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
        quebecClaimFrench.Sector__c = 'CA';
        quebecClaimFrench.AccountId = louvre.Id;
        quebecClaimFrench.Distributor__c = bigCustomer.Id;
        quebecClaimFrench.ContactId = frankLloyd.Id;
        quebecClaimFrench.Product__c = organicShingle.Id;
        quebecClaimFrench.Replacement_Product__c = glassShingle.Id;
        quebecClaimFrench.Preferred_Language__c = 'Quebec French';
        claims.add(quebecClaimFrench);


// ROM claim with a claim type of K
Case romClaim = new Case();
        romClaim.Description = 'Organic Residential Claim created by Test Case';
        romClaim.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
        romClaim.Sector__c = 'CA';
        romClaim.AccountId = rom.Id;
        romClaim.Distributor__c = bigCustomer.Id;
        romClaim.ContactId = frankLloyd.Id;
        romClaim.Product__c = organicShingle.Id;
        romClaim.Replacement_Product__c = glassShingle.Id;
        romClaim.Preferred_Language__c = 'Quebec French';
        claims.add(romClaim);


Case guggenheimClaim = new Case();
        guggenheimClaim.Description = 'Regular Residential Claim With Cracking';
        guggenheimClaim.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
        guggenheimClaim.Sector__c = 'CA';
        guggenheimClaim.AccountId = guggenheim.Id;
        guggenheimClaim.Distributor__c = bigCustomer.Id;
        guggenheimClaim.ContactId = frankGehry.Id;
        guggenheimClaim.Preferred_Language__c = 'English';
        claims.add(guggenheimClaim);

Case bilbaoClaim = new Case();
        bilbaoClaim.Description = 'Regular Residential Claim With Cracking';
        bilbaoClaim.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
        bilbaoClaim.Sector__c = 'CA';
        bilbaoClaim.AccountId = bilbao.Id;
        bilbaoClaim.Distributor__c = bigCustomer.Id;
        bilbaoClaim.ContactId = frankGehry.Id;
        bilbaoClaim.Preferred_Language__c = 'English';
        claims.add(bilbaoClaim);


        
Case regClaim = new Case();
        regClaim.Description = 'Regular Residential Claim With Cracking';
        regClaim.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
        regClaim.Sector__c = 'CA';
        regClaim.AccountId = nypl.Id;
        regClaim.Distributor__c = bigCustomer.Id;
        regClaim.ContactId = frankLloyd.Id;
        regClaim.Preferred_Language__c = 'English';
        claims.add(regClaim);

// We have to insert the claims so they get ID's before we can create the claimtypes. Pain.        
insert claims;        

Claim_Type__c guggenheimGlass = new Claim_Type__c();
        guggenheimGlass.Case__c = guggenheimClaim.Id;
        guggenheimGlass.Is_Primary__c = true;
        guggenheimGlass.Product_Type__c = 'B Glass';
        guggenheimGlass.Concern__c = 'Cracking';
        claimTypes.add(guggenheimGlass);

Claim_Type__c organicCracking = new Claim_Type__c();
        organicCracking.Case__c = orgClaim.Id;
        organicCracking.Is_Primary__c = true;
        organicCracking.Product_Type__c = 'A Organic';
        organicCracking.Concern__c = 'Cracking'; 
        claimTypes.add(organicCracking);

Claim_Type__c quebecType = new Claim_Type__c();
        quebecType.Case__c = quebecClaim.Id;
        quebecType.Is_Primary__c = true;
        quebecType.Product_Type__c = 'A Organic';
        quebecType.Concern__c = 'Granule Loss';     
        claimTypes.add(quebecType);
            
Claim_Type__c lamOrg = new Claim_Type__c();
        lamOrg.Case__c = quebecClaim.Id;
        lamOrg.Is_Primary__c = false;
        lamOrg.Product_Type__c = 'C Lam/Org';
        lamOrg.Concern__c = 'Cracking';
        claimTypes.add(lamOrg);

Claim_Type__c totalOrg = new Claim_Type__c();
        totalOrg.Case__c = quebecClaimFrench.Id;
        totalOrg.Is_Primary__c = true;
        totalOrg.Product_Type__c = 'J Total';
        totalOrg.Concern__c = 'Granule Loss';
        claimTypes.add(totalOrg);

Claim_Type__c romOrg = new Claim_Type__c();
        romOrg.Case__c = romClaim.Id;
        romOrg.Is_Primary__c = true;
        romOrg.Product_Type__c = 'K Lock';
        romOrg.Concern__c = 'Cracking';
        claimTypes.add(romOrg);        

Claim_Type__c bilbaoGlass = new Claim_Type__c();
        bilbaoGlass.Case__c = bilbaoClaim.Id;
        bilbaoGlass.Is_Primary__c = true;
        bilbaoGlass.Product_Type__c = 'D Lam/Glass';
        bilbaoGlass.Concern__c = 'Cracking';
        claimTypes.add(bilbaoGlass);

        
insert claimTypes;
        
// We need to insert some Lab Samples and Lab Test Results
// partly because there's an approval process
// 

list<Lab_Sample__c> labSamples = new list<Lab_Sample__c>();
        
    // To create a lab sample, the Claim has to be in Lab
    quebecClaim.Claim_Stage__c = 'In Lab';
    update quebecClaim;
        
	Lab_Sample__c quebecClaimSample = new Lab_Sample__c();
        quebecClaimSample.Case__c = quebecClaim.Id;
        quebecClaimSample.Status__c = 'Sample Received';
        quebecClaimSample.Observation__c = 'Ahab is for ever Ahab, man. This whole act\'s immutably decreed. \'Twas rehearsed by thee and me a billion years before this ocean rolled. Fool! I am the Fates\' lieutenant, I act under orders.';
		quebecClaimSample.CurrencyIsoCode = 'CAD';
		quebecClaimSample.Plant_Feedback_Type__c = 'Algae';
        quebecClaimSample.Generate_Sample_Number__c = true;
        quebecClaimSample.In_Brampton__c = true;
        quebecClaimSample.Received_Date_Brampton__c = System.Today().addDays(-7);
   	labSamples.add(quebecClaimSample);
        
// Inserting lab samples causes a TOO MANY SOQL	query error because of the lab sample service
// This is...not good        
// insert labSamples;


        // Technically we probably need a claimtype for every single product type
        // (none)
        // A Organic
        // B Glass
        // C Lam/Org
        // D Lam/Glass
        // E Coated Rolls
        // F Mod Bit
        // G Felt
        // H Asphalt
        // I Fibrebrd
        // J Total
        // K Lock
        // L ArmourGd
        // M Protecbrd
        // N Poly ISO
        // P Roof-Fast
        // Q Gold Shield
        // R Adhs/Ctgs
        // Z Not IKO
        





        
        
        
list<Campaign> campaigns = new List<Campaign>();

Campaign c1 = new Campaign();
	    c1.Name = 'Test 1';
        c1.Description = 'Test 2';
        campaigns.add(c1);
Campaign c2 = new Campaign();
	    c2.Name = 'Test 1';
        c2.Description = 'Test 2';
        campaigns.add(c2);
Campaign c3 = new Campaign();
	    c3.Name = 'Test 1';
        c3.Description = 'Test 2';
        campaigns.add(c3);
Campaign c4 = new Campaign();
	    c4.Name = 'Test 1';
        c4.Description = 'Test 2';
        campaigns.add(c4);
Campaign c5 = new Campaign();
	    c5.Name = 'Test 1';
        c5.Description = 'Test 2';
        campaigns.add(c5);
        
        
        insert campaigns;


	// Create all of our conga queries. This part needs to be maintained as things change in production
	// So we should still consider the production system as the master for conga queries
	// If there's a difference please tell a developer so this can be updated
	// We should also update this so that if the query exists it doesn't create it
	List<APXTConga4__Conga_Merge_Query__c> queries = createCongaQueries();
		insert queries;

    List<APXTConga4__Conga_Template__c> templates = createCongaTemplates();
        insert templates;
        
	customSettingUpdate();
    }

    public static list<APXTConga4__Conga_Merge_Query__c> createCongaQueries() {
		List<APXTConga4__Conga_Merge_Query__c> queries = new List<APXTConga4__Conga_Merge_Query__c>();
        
        APXTConga4__Conga_Merge_Query__c query = new APXTConga4__Conga_Merge_Query__c();
        	query.APXTConga4__Name__c = 'Case Summary - Lab Samples';
        	query.APXTConga4__Query__c = 'SELECT Case__c, Case_Closed__c, Case_Closed_Date__c, Case_Description__c, Case_Installation_Date__c, Case_Leaking__c, Case_Number__c, Case_Open_Date__c, Case_Priority_Indicator__c, Case_Priority_Score__c, Case_PrioritySort__c, Case_Subject__c, Claim_Number__c, Claim_Stage__c, Claim_Sub_Stage__c, Courier__c, Courier_to_Research_Lab__c, CreatedBy.Name, CreatedDate, Date_Shipped_To_Plant__c, Days_Opened__c, Disposition_of_Sample__c, Disposition_Plant__c, Feedback__c, Generate_Sample_Number__c, Generate_Tests__c, Id, In_Brampton__c, Incomplete_Documentation__c, IsDeleted, Lab_Sample_Approved_Date__c, LabSamplePrioritySort__c, LastActivityDate, LastModifiedBy.Name, LastModifiedDate, Legacy_Id__c, Name, Number_of_Shingles__c, Observation__c, Owner.Name, Pending_Approval_Date__c, Plant_Feedback_Type__c, PRM__c, Product_Details__c, Received_Date_Brampton__c, Received_Date_Kankakee__c, Recent_Manufacture_Date__c, Sample_Number__c, Sequence_Number__c, Sequence_Prefix__c, Shipping_Date_to_Research_Lab__c, Status__c, SystemModstamp, Technician_Time__c, Test_Generation_Date__c, Time_in_Research__c, Tracking_No_to_Research_Lab__c, Tracking_Number__c, Year__c, (SELECT Case_Closed__c,CreatedDate,Feedback__c,Id,IsDeleted,Lab_Sample__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Manufacture_Date__c,Manufacturing_Info__c,Name,Notes__c,Owner.Name,Producing_Plant__c,Product_Colour__c,Product_Info__c,Product__c,Tape_Code__r.Product__r.Name,Quantity__c,SystemModstamp,Tape_Code_Less_Than_a_Year_Old__c,Tape_Code_Name__c,Tape_Code__c FROM Lab_Sample_Tape_Codes__r ORDER BY Name DESC), (SELECT Case_Closed__c,Id,IsDeleted,Lab_Sample_Approval_Status__c,Lab_Sample__r.Name,Lab_Test__c,Name,N_A__c,Owner.Name,Tape_Code__c,Test_Date__c,Test_Result__c,Test_Status__c, CreatedBy.Name, LastModifiedBy.Name FROM Lab_Test_Results__r ORDER BY Name DESC), (SELECT Case_Number__c,Claim_Number__c,CreatedBy.Name,CreatedDate,Date_Sample_Received_By_Plant__c,Description__c,Id,IsDeleted,Lab_Sample__r.Name,Name,PRM_Approved__c,PRM__c,Product_Code__c,Product_Colour__c,Product_Name__c FROM PRM_Comments__r ORDER BY Name DESC) FROM Lab_Sample__c WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Name ASC';
        	query.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(query);

        APXTConga4__Conga_Merge_Query__c labSampleHistory = new APXTConga4__Conga_Merge_Query__c();
        	labSampleHistory.APXTConga4__Name__c = 'Case Summary - Lab Sample History';
        	labSampleHistory.APXTConga4__Query__c = 'SELECT ParentId, CreatedBy.Name, CreatedDate, Field, IsDeleted, NewValue, OldValue FROM Lab_Sample__History WHERE ParentId = {pv0} AND IsDeleted = false ORDER BY CreatedDate DESC';
        	labSampleHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(labSampleHistory);
        
        APXTConga4__Conga_Merge_Query__c labSampleApprovalHistory = new APXTConga4__Conga_Merge_Query__c();
        	labSampleApprovalHistory.APXTConga4__Name__c = 'Case Summary - Lab Sample Approval History';
        	labSampleApprovalHistory.APXTConga4__Query__c = 'SELECT Id, ProcessDefinitionId, ProcessDefinition.Name, ProcessDefinition.Description, ProcessDefinition.Id, (SELECT Id, IsDeleted, LastActorId,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName FROM Nodes ORDER BY ProcessNodeId DESC LIMIT 1), (SELECT Id, StepStatus,Actor.Name, CreatedDate, Comments, ProcessInstanceId FROM StepsAndWorkitems ORDER BY CreatedDate DESC) FROM ProcessInstance WHERE ProcessInstance.TargetObjectId = {pv0} ORDER BY ProcessInstance.CreatedDate DESC';
        	labSampleApprovalHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(labSampleApprovalHistory);

        APXTConga4__Conga_Merge_Query__c labSamplesQvar1Id = new APXTConga4__Conga_Merge_Query__c();
        	labSamplesQvar1Id.APXTConga4__Name__c = 'Case Summary - Lab Samples - QVar1Id';
        	labSamplesQvar1Id.APXTConga4__Query__c = 'SELECT Id FROM Payment_Request__c WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Name ASC LIMIT 50';
        	labSamplesQvar1Id.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(labSamplesQvar1Id);

        APXTConga4__Conga_Merge_Query__c labSamplesQvar2Id = new APXTConga4__Conga_Merge_Query__c();
        	labSamplesQvar2Id.APXTConga4__Name__c = 'Case Summary - Lab Samples - QVar0Id';
        	labSamplesQvar2Id.APXTConga4__Query__c = 'SELECT Id FROM Lab_Sample__c WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Name ASC LIMIT 50';
        	labSamplesQvar2Id.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(labSamplesQvar2Id);

		APXTConga4__Conga_Merge_Query__c caseSummaryPaymentRequestHistory = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryPaymentRequestHistory.APXTConga4__Name__c = 'Case Summary - Payment Request History';
        	caseSummaryPaymentRequestHistory.APXTConga4__Query__c = 'SELECT ParentId, CreatedBy.Name, CreatedDate, Field, IsDeleted, NewValue, OldValue FROM Payment_Request__History WHERE ParentId = \'{pv0}\' AND IsDeleted = false ORDER BY CreatedDate DESC';
        	caseSummaryPaymentRequestHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryPaymentRequestHistory);

		APXTConga4__Conga_Merge_Query__c caseSummaryPaymentRequest = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryPaymentRequest.APXTConga4__Name__c = 'Case Summary - Payment Requests';
        	caseSummaryPaymentRequest.APXTConga4__Query__c = 'SELECT Account__c, Account_Address_Verification_Status__c, Approved_Date__c, Case__c, Case_Closed__c, Conga_Payment_Request_Not_Possible__c, Contact__c, Contact_Address_Verification_Status__c, Contractor_Account_Verified__c, CreatedById, CreatedDate, Credit_Number__c, Customer_Mapic_Number__c, Date_Submitted__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Legacy_Id__c, Name, Note_Type__c, Parent_Account_Verified__c, Parent_Contractor_Account_Verified__c, Payment_Request_Line_Item__c, RecordTypeId, Reference_Number__c, SystemModstamp, Taxes__c, Total__c, Total_of_all_Items__c, (SELECT Amount__c,CreatedBy.Name,CreatedDate,Id,IsDeleted,Item_Description__c,Item_Number__c,Legacy_Id__c,Name,Payment_Request__c,Quantity__c,Units__c FROM Payment_Request_Line_Items__r ORDER BY Name ASC) FROM Payment_Request__c  WHERE Case__c = \'5005C000003YXPBQA4\' AND IsDeleted = false ORDER BY Date_Submitted__c DESC , Approved_Date__c DESC';
        	caseSummaryPaymentRequest.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryPaymentRequest);
        
		APXTConga4__Conga_Merge_Query__c caseSummaryCaseOwner = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryCaseOwner.APXTConga4__Name__c = 'Case Summary - Case Owner';
        	caseSummaryCaseOwner.APXTConga4__Query__c = 'SELECT Name FROM User WHERE Id = {pv0}';
        	caseSummaryCaseOwner.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryCaseOwner);
        
		APXTConga4__Conga_Merge_Query__c caseSummaryClaimType = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryClaimType.APXTConga4__Name__c = 'Case Summary - Claim Types';
        	caseSummaryClaimType.APXTConga4__Query__c = 'SELECT Case__c, Concern__c, CreatedBy.Name, CreatedDate, Glass_Organic__c, Id, Is_Primary__c, IsDeleted, Name, Product_Type__c FROM Claim_Type__c  WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Is_Primary__c DESC , Name ASC';
        	caseSummaryClaimType.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryClaimType);
        
		APXTConga4__Conga_Merge_Query__c caseSummarySettlementConditions = new APXTConga4__Conga_Merge_Query__c();
        	caseSummarySettlementConditions.APXTConga4__Name__c = 'Case Summary - Settlement Conditions';
        	caseSummarySettlementConditions.APXTConga4__Query__c = 'SELECT Case__c, Condition_Template__c, Condition_Text__c, CreatedById, CreatedDate, Id, IsDeleted, LastModifiedById, LastModifiedDate, Name, Order__c FROM Settlement_Condition__c  WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Order__c ASC';
        	caseSummarySettlementConditions.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummarySettlementConditions);

        APXTConga4__Conga_Merge_Query__c caseSummaryApprovalHistory = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryApprovalHistory.APXTConga4__Name__c = 'Case Summary - Approval History';
        	caseSummaryApprovalHistory.APXTConga4__Query__c = 'SELECT Id, ProcessDefinitionId, ProcessDefinition.Name, ProcessDefinition.Description, ProcessDefinition.Id, (SELECT Id, IsDeleted, LastActorId,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName FROM Nodes ORDER BY ProcessNodeId DESC LIMIT 1), (SELECT Id, StepStatus,Actor.Name, CreatedDate, Comments, ProcessInstanceId FROM StepsAndWorkitems ORDER BY CreatedDate DESC) FROM ProcessInstance WHERE ProcessInstance.TargetObjectId = \'{pv0}\' ORDER BY ProcessInstance.CreatedDate DESC';
        	caseSummaryApprovalHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryApprovalHistory);

        APXTConga4__Conga_Merge_Query__c warrantyContractor = new APXTConga4__Conga_Merge_Query__c();
        	warrantyContractor.APXTConga4__Name__c = 'Warranty - Contractor';
        	warrantyContractor.APXTConga4__Query__c = 'SELECT Contractor__r.BillingAddress, Contractor__r.BillingCity, Contractor__r.BillingPostalCode, Contractor__r.BillingState, Contractor__r.BillingStateCode, Contractor__r.BillingStreet, Contractor__r.Fax, Contractor__r.Name, Contractor__r.Phone, Contractor__r.Registration__c, Contractor__r.IAP_Registration_Expiry_Date__c, Contractor__r.OwnerId FROM Warranty__c  WHERE Id = \'{pv0}\'';
        	warrantyContractor.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(warrantyContractor);

        APXTConga4__Conga_Merge_Query__c relatedProducts = new APXTConga4__Conga_Merge_Query__c();
        	relatedProducts.APXTConga4__Name__c = 'Related Products';
        	relatedProducts.APXTConga4__Query__c = 'SELECT Case__r.Id, Product__r.Description, Product__r.Name, Case__c, Name, Product__c, Product_Colour__c, Product_Description__c, Quantity__c, Unit_of_Measure__c FROM Related_Product__c  WHERE Case__r.Id = \'{pv0}\'';
        	relatedProducts.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(relatedProducts);
        
        APXTConga4__Conga_Merge_Query__c caseSummaryAccountQVar2Id = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryAccountQVar2Id.APXTConga4__Name__c = 'Case Summary - Account - QVar2Id';
        	caseSummaryAccountQVar2Id.APXTConga4__Query__c = 'SELECT Id FROM Account WHERE Id = \'{pv0}\' AND IsDeleted = false ORDER BY Name ASC LIMIT 1';
        	caseSummaryAccountQVar2Id.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryAccountQVar2Id);

        APXTConga4__Conga_Merge_Query__c paymentRequestCaseNew = new APXTConga4__Conga_Merge_Query__c();
        	paymentRequestCaseNew.APXTConga4__Name__c = 'Payment Request - Case - New';
        	paymentRequestCaseNew.APXTConga4__Query__c = 'SELECT Case__r.Conga_Alternate_Contact_Name__c, toLabel(Case__r.Brand__c), Case__r.Conga_Contact_Address__c, Case__r.conga_country__c, Case__r.Conga_Mailing_City__c, Case__r.Conga_Mailing_State__c, Case__r.Conga_Mailing_Street__c,Case__r.Conga_Postal_Code__c, Case__r.Conga_Contact_Name__c, Case__r.Conga_Account_Parent__c,Case__r.Claim_Number__c, Case__r.Plant_Name__c FROM Payment_Request__c WHERE Id = \'{pv0}\'';
        	paymentRequestCaseNew.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(paymentRequestCaseNew);

        APXTConga4__Conga_Merge_Query__c settlementConditions = new APXTConga4__Conga_Merge_Query__c();
        	settlementConditions.APXTConga4__Name__c = 'Settlement Conditions';
        	settlementConditions.APXTConga4__Query__c = 'SELECT Id, Condition_Text__c, Condition_Template__c, Order__c FROM Settlement_Condition__c WHERE Case__c = \'{pv0}\' ORDER BY Order__c ASC';
        	settlementConditions.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(settlementConditions);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c distributor = new APXTConga4__Conga_Merge_Query__c();
        	distributor.APXTConga4__Name__c = 'Distributor';
        	distributor.APXTConga4__Query__c = 'SELECT Distributor__r.BillingCity FROM Case  WHERE Id = \'{pv0}\'';
        	distributor.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(distributor);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c brandLongName = new APXTConga4__Conga_Merge_Query__c();
        	brandLongName.APXTConga4__Name__c = 'Brand Long Name';
        	brandLongName.APXTConga4__Query__c = 'SELECT toLabel(Brand__c) FROM Case  WHERE Id = \'{pv0}\'';
        	brandLongName.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(brandLongName);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c altContact = new APXTConga4__Conga_Merge_Query__c();
        	altContact.APXTConga4__Name__c = 'Alternate Contact (Home Owner)';
        	altContact.APXTConga4__Query__c = 'SELECT Alternate_Contact__r.FirstName, Alternate_Contact__r.LastName, Alternate_Contact__r.MobilePhone, Alternate_Contact__r.Name, Alternate_Contact__r.OtherPhone, Alternate_Contact__r.Phone, Alternate_Contact__r.Salutation FROM Case WHERE Id = \'{pv0}\'';
        	altContact.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(altContact);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c relatedWarranty = new APXTConga4__Conga_Merge_Query__c();
        	relatedWarranty.APXTConga4__Name__c = 'Diamond Shield Limited Warranty';
        	relatedWarranty.APXTConga4__Query__c = 'SELECT Warranty__r.Contractor__c, Warranty__r.Cost_Per_Square_Foot__c, Warranty__r.Square_Footage_of_Installation__c, Warranty__r.Warranty_Term__c FROM Case  WHERE Id = \'{pv0}\'';
        	relatedWarranty.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(relatedWarranty);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c warrantyOwner = new APXTConga4__Conga_Merge_Query__c();
        	warrantyOwner.APXTConga4__Name__c = 'Warranty Certificate - Warranty Owner';
        	warrantyOwner.APXTConga4__Query__c = 'SELECT Building__r.BillingAddress, Building__r.BillingPostalCode, Building__r.BillingState, Building__r.BillingStreet, Building__r.BillingCity,  Consultant__r.BillingAddress, Consultant__r.BillingCity, Consultant__r.BillingState, Consultant__r.BillingStreet, Consultant__r.BillingPostalCode, Warranty_Owner_Company__r.BillingAddress, Warranty_Owner_Company__r.BillingCity, Warranty_Owner_Company__r.BillingPostalCode, Warranty_Owner_Company__r.BillingState, Warranty_Owner_Company__r.BillingStreet, Warranty_Owner_Company__r.Fax, Warranty_Owner_Company__r.Name, Warranty_Owner_Company__r.Phone FROM Warranty__c WHERE Id = \'{pv0}\'';
        	warrantyOwner.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(warrantyOwner);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c warrantyArchitect = new APXTConga4__Conga_Merge_Query__c();
        	warrantyArchitect.APXTConga4__Name__c = 'Warranty Certificate - Architect';
        	warrantyArchitect.APXTConga4__Query__c = 'SELECT Architect__r.BillingAddress, Architect__r.BillingCity, Architect__r.BillingPostalCode, Architect__r.BillingState, Architect__r.BillingStreet, Architect__r.Fax, Architect__r.Name, Architect__r.Phone FROM Warranty__c  WHERE Id = \'{pv0}\'';
        	warrantyArchitect.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(warrantyArchitect);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c warrantyRoofing = new APXTConga4__Conga_Merge_Query__c();
        	warrantyRoofing.APXTConga4__Name__c = 'Warranty Roofing Products';
        	warrantyRoofing.APXTConga4__Query__c = 'SELECT Product__r.Colour__c, Product__r.Description, Product__r.Name, Product__r.ProductCode, Membrane_Type__c, Name, Product__c, Product_Colour__c, Product_Description__c, Warranty__c FROM Related_Product__c  WHERE Warranty__r.Id = \'{pv0}\' AND Membrane_Type__c = \'Roofing\'';
        	warrantyRoofing.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(warrantyRoofing);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c warrantyFlashing = new APXTConga4__Conga_Merge_Query__c();
        	warrantyFlashing.APXTConga4__Name__c = 'Warranty Flashing Products';
        	warrantyFlashing.APXTConga4__Query__c = 'SELECT Product__r.Colour__c, Product__r.Description, Product__r.Name, Product__r.ProductCode, Membrane_Type__c, Name, Product__c, Product_Colour__c, Product_Description__c, Warranty__c FROM Related_Product__c  WHERE Warranty__r.Id = \'{pv0}\' AND Membrane_Type__c = \'Flashing\'';
        	warrantyFlashing.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(warrantyFlashing);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c paymentRequestLine = new APXTConga4__Conga_Merge_Query__c();
        	paymentRequestLine.APXTConga4__Name__c = 'Payment Request - Payment Request Line - New';
        	paymentRequestLine.APXTConga4__Query__c = 'SELECT Amount__c, Item_Description__c, Item_Number__c, Payment_Request__c, Quantity__c, Units__c FROM Payment_Request_Line_Item__c WHERE Payment_Request__c = \'{pv0}\' ORDER BY Item_Number__c ASC';
        	paymentRequestLine.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(paymentRequestLine);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c paymentAccount = new APXTConga4__Conga_Merge_Query__c();
        	paymentAccount.APXTConga4__Name__c = 'Payment - Account - Contact - Address Info';
        	paymentAccount.APXTConga4__Query__c = 'SELECT Account__r.BillingAddress, Account__r.BillingCity, Account__r.BillingPostalCode, Account__r.BillingState, Account__r.BillingStateCode, Account__r.BillingStreet, Contact__r.MailingAddress, Contact__r.MailingCity, Contact__r.MailingPostalCode, Contact__r.MailingState, Contact__r.MailingStateCode, Contact__r.MailingStreet FROM Payment_Request__c  WHERE Id = \'{pv0}\'';
        	paymentAccount.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(paymentAccount);
        
        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c alternateContact = new APXTConga4__Conga_Merge_Query__c();
        	alternateContact.APXTConga4__Name__c = 'Case Summary - Alternate Contact';
        	alternateContact.APXTConga4__Query__c = 'SELECT Name, Account.Name, Owner.Name, Title, MailingStreet, MailingCity, MailingState, MailingPostalCode, Phone, MobilePhone, Email, Fax, CreatedBy.Name, LastModifiedBy.Name, CreatedDate, LastModifiedDate FROM Contact WHERE Id = \'{pv0}\'';
        	alternateContact.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(alternateContact);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseLabSampleHistory = new APXTConga4__Conga_Merge_Query__c();
        	caseLabSampleHistory.APXTConga4__Name__c = 'Case Summary - Lab Sample History';
        	caseLabSampleHistory.APXTConga4__Query__c = 'SELECT ParentId, CreatedBy.Name, CreatedDate, Field, IsDeleted, NewValue, OldValue FROM Lab_Sample__History WHERE ParentId = {pv0} AND IsDeleted = false ORDER BY CreatedDate DESC';
        	caseLabSampleHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseLabSampleHistory);
        
        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c relatedCases = new APXTConga4__Conga_Merge_Query__c();
        	relatedCases.APXTConga4__Name__c = 'Case Summary - Related Cases';
        	relatedCases.APXTConga4__Query__c = 'SELECT CaseNumber, Claim_Number__c, Claim_Stage__c, Claim_Sub_Stage__c, Id, ParentId, Subject FROM Case  WHERE ParentId = \'{pv0}\' ORDER BY CaseNumber ASC';
        	relatedCases.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(relatedCases);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c paymentRequestHistory = new APXTConga4__Conga_Merge_Query__c();
        	paymentRequestHistory.APXTConga4__Name__c = 'Case Summary - Payment Request History';
        	paymentRequestHistory.APXTConga4__Query__c = 'SELECT ParentId, CreatedBy.Name, CreatedDate, Field, IsDeleted, NewValue, OldValue FROM Payment_Request__History WHERE ParentId = \'{pv0}\' AND IsDeleted = false ORDER BY CreatedDate DESC';
        	paymentRequestHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(paymentRequestHistory);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c labSampleApprovals = new APXTConga4__Conga_Merge_Query__c();
        	labSampleApprovals.APXTConga4__Name__c = 'Case Summary - Lab Sample Approval History';
        	labSampleApprovals.APXTConga4__Query__c = 'SELECT Id, ProcessDefinitionId, ProcessDefinition.Name, ProcessDefinition.Description, ProcessDefinition.Id, (SELECT Id, IsDeleted, LastActorId,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName FROM Nodes ORDER BY ProcessNodeId DESC LIMIT 1), (SELECT Id, StepStatus,Actor.Name, CreatedDate, Comments, ProcessInstanceId FROM StepsAndWorkitems ORDER BY CreatedDate DESC) FROM ProcessInstance WHERE ProcessInstance.TargetObjectId = {pv0} ORDER BY ProcessInstance.CreatedDate DESC';
        	labSampleApprovals.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(labSampleApprovals);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseRecordType = new APXTConga4__Conga_Merge_Query__c();
        	caseRecordType.APXTConga4__Name__c = 'Case Summary - Record Type';
        	caseRecordType.APXTConga4__Query__c = 'SELECT Id, Name, SobjectType FROM RecordType  WHERE Id = \'{pv0}\' LIMIT 1';
        	caseRecordType.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseRecordType);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseFeed = new APXTConga4__Conga_Merge_Query__c();
        	caseFeed.APXTConga4__Name__c = 'Case Summary - Case Feed';
        	caseFeed.APXTConga4__Query__c = 'SELECT Body, CommentCount, CreatedBy.Name, CreatedDate, Id, IsDeleted, LikeCount, LinkUrl, ParentId, RelatedRecordId, Title FROM CaseFeed  WHERE ParentId = \'{pv0}\' ORDER BY CreatedDate DESC';
        	caseFeed.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseFeed);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseProducts = new APXTConga4__Conga_Merge_Query__c();
        	caseProducts.APXTConga4__Name__c = 'Case Summary - Case Products';
        	caseProducts.APXTConga4__Query__c = 'SELECT Id, Name, Product__r.Name, Product_Colour__c, Product_Description__c, Quantity__c, RecordType.Name, Unit_of_Measure__c, Warranty__r.Name FROM Related_Product__c WHERE Case__c = \'{pv0}\' ORDER BY Name ASC';
        	caseProducts.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseProducts);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseComments = new APXTConga4__Conga_Merge_Query__c();
        	caseComments.APXTConga4__Name__c = 'Case Summary - Case Comments';
        	caseComments.APXTConga4__Query__c = 'SELECT CommentBody, CreatedBy.Name, CreatedDate, Id, IsDeleted, IsPublished, ParentId FROM CaseComment  WHERE ParentId = \'{pv0}\' AND IsDeleted = false ORDER BY CreatedDate DESC';
        	caseComments.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseComments);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseHistory = new APXTConga4__Conga_Merge_Query__c();
        	caseHistory.APXTConga4__Name__c = 'Case Summary - Case History';
        	caseHistory.APXTConga4__Query__c = 'SELECT CaseId, CreatedBy.Name, CreatedDate, Field, IsDeleted, NewValue, OldValue FROM CaseHistory WHERE CaseId = \'{pv0}\' AND IsDeleted = false ORDER BY CreatedDate DESC';
        	caseHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseHistory);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseWarranty = new APXTConga4__Conga_Merge_Query__c();
        	caseWarranty.APXTConga4__Name__c = 'Case Summary - Warranty';
        	caseWarranty.APXTConga4__Query__c = 'SELECT Architect__c,Building__c,Confirmation_of_Repairs__c,Consultant_Fax__c,Consultant_Phone__c,Consultant_PostalCode__c,Consultant__c,Contractor_Address__c,Contractor_BillingCity__c,Contractor_BillingPostalCode__c,Contractor_BillingState__c,Contractor_BillingStreet__c,Contractor_Phone__c,Contractor__c,Contract_IAAP_Expiry_Date__c,Contract_IAAP_Registered_BUR__c,Contract_IAAP_Registered_SBS__c,Contract_Registration__c,Count_of_Associated_Related_Products__c,CreatedById,CreatedDate,Days_Since_Last_Modified__c,Deck_Type__c,Deficiency_Status_2_Year_Inspection__c,Details_Roof_Specification__c,Expired__c,Fasteners__c,Final_Inspection_Report_Letter__c,Id,IKO_External_ID__c,IKO_Source_System__c,Installation_Deficiency_Status__c,Insulation__c,Invoice_Amount_Override__c,Invoice_Amount__c,Invoice_Sent_Date__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Legacy__c,Name,New_Roof__c,Note__c,Other_Products__c,Overlay_Board__c,OwnerId,Payment_Received_Date__c,Proof_of_Purchase__c,RecordTypeId,Recover__c,Registration_Prefix__c,Related_Product__c,Re_Cover_Limited_Warranty_Application__c,Roof_Plan__c,Roof_Section__c,Sequence_Number__c,Slope__c,Square_Footage_of_Installation__c,Status_Date_Issued_Not_Issued_Date__c,SystemModstamp,Tear_Off__c,Thermoscan_Analysis__c,Transferred__c,Two_Year_Inspection_Complete_Date__c,Two_Year_Inspection_Due_Date__c,Type__c,Vapour_Retardant__c,Warranty_Age__c,Warranty_Expiry_Date__c,Warranty_Owner_Address__c,Warranty_Owner_City__c,Warranty_Owner_Company__c,Warranty_Owner_Fax__c,Warranty_Owner_Phone__c,Warranty_Owner_PostalCode__c,Warranty_Owner__c,Warranty_Registration_Id__c,Warranty_Start_Date__c,Warranty_Status__c,Warranty_Substatus__c,Warranty_Term_FR__c,Warranty_Term_Text__c,Warranty_Term_Years__c,Warranty_Term__c,Warranty_Transfer_Count__c,WCMS_Approver__c,Work_Completion_Date__c,Work_Start_Date__c, (SELECT Id, Name, Product__r.Name, Product_Colour__c, Product_Description__c, Quantity__c, RecordType.Name, Unit_of_Measure__c, Warranty__r.Name FROM Related_Warranty_Products__r), (SELECT Distributor__c,Distributor__r.Name,Id,Name,Warranty__c FROM Warranty_Distributors__r ORDER BY Name ASC) FROM Warranty__c WHERE Id = \'{pv0}\'';
        	caseWarranty.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseWarranty);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseApprovalHistory = new APXTConga4__Conga_Merge_Query__c();
        	caseApprovalHistory.APXTConga4__Name__c = 'Case Summary - Approval History';
        	caseApprovalHistory.APXTConga4__Query__c = 'SELECT Id, ProcessDefinitionId, ProcessDefinition.Name, ProcessDefinition.Description, ProcessDefinition.Id, (SELECT Id, IsDeleted, LastActorId,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName FROM Nodes ORDER BY ProcessNodeId DESC LIMIT 1), (SELECT Id, StepStatus,Actor.Name, CreatedDate, Comments, ProcessInstanceId FROM StepsAndWorkitems ORDER BY CreatedDate DESC) FROM ProcessInstance WHERE ProcessInstance.TargetObjectId = \'{pv0}\' ORDER BY ProcessInstance.CreatedDate DESC';
        	caseApprovalHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseApprovalHistory);
		
        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c casePaymentRequests = new APXTConga4__Conga_Merge_Query__c();
        	casePaymentRequests.APXTConga4__Name__c = 'Case Summary - Payment Requests';
        	casePaymentRequests.APXTConga4__Query__c = 'SELECT Account__c, Account_Address_Verification_Status__c, Approved_Date__c, Case__c, Case_Closed__c, Conga_Payment_Request_Not_Possible__c, Contact__c, Contact_Address_Verification_Status__c, Contractor_Account_Verified__c, CreatedById, CreatedDate, Credit_Number__c, Customer_Mapic_Number__c, Date_Submitted__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Legacy_Id__c, Name, Note_Type__c, Parent_Account_Verified__c, Parent_Contractor_Account_Verified__c, Payment_Request_Line_Item__c, RecordTypeId, Reference_Number__c, SystemModstamp, Taxes__c, Total__c, Total_of_all_Items__c, (SELECT Amount__c,CreatedBy.Name,CreatedDate,Id,IsDeleted,Item_Description__c,Item_Number__c,Legacy_Id__c,Name,Payment_Request__c,Quantity__c,Units__c FROM Payment_Request_Line_Items__r ORDER BY Name ASC) FROM Payment_Request__c  WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Date_Submitted__c DESC , Approved_Date__c DESC';
        	casePaymentRequests.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(casePaymentRequests);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseSettlementConditions = new APXTConga4__Conga_Merge_Query__c();
        	caseSettlementConditions.APXTConga4__Name__c = 'Case Summary - Settlement Conditions';
        	caseSettlementConditions.APXTConga4__Query__c = 'SELECT Case__c, Condition_Template__c, Condition_Text__c, CreatedById, CreatedDate, Id, IsDeleted, LastModifiedById, LastModifiedDate, Name, Order__c FROM Settlement_Condition__c  WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Order__c ASC';
        	caseSettlementConditions.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSettlementConditions);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseClaimTypes = new APXTConga4__Conga_Merge_Query__c();
        	caseClaimTypes.APXTConga4__Name__c = 'Case Summary - Claim Types';
        	caseClaimTypes.APXTConga4__Query__c = 'SELECT Case__c, Concern__c, CreatedBy.Name, CreatedDate, Glass_Organic__c, Id, Is_Primary__c, IsDeleted, Name, Product_Type__c FROM Claim_Type__c  WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Is_Primary__c DESC , Name ASC';
        	caseClaimTypes.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseClaimTypes);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseLabSamples = new APXTConga4__Conga_Merge_Query__c();
        	caseLabSamples.APXTConga4__Name__c = 'Case Summary - Lab Samples';
        	caseLabSamples.APXTConga4__Query__c = 'SELECT Case__c, Case_Closed__c, Case_Closed_Date__c, Case_Description__c, Case_Installation_Date__c, Case_Leaking__c, Case_Number__c, Case_Open_Date__c, Case_Priority_Indicator__c, Case_Priority_Score__c, Case_PrioritySort__c, Case_Subject__c, Claim_Number__c, Claim_Stage__c, Claim_Sub_Stage__c, Courier__c, Courier_to_Research_Lab__c, CreatedBy.Name, CreatedDate, Date_Shipped_To_Plant__c, Days_Opened__c, Disposition_of_Sample__c, Disposition_Plant__c, Feedback__c, Generate_Sample_Number__c, Generate_Tests__c, Id, In_Brampton__c, Incomplete_Documentation__c, IsDeleted, Lab_Sample_Approved_Date__c, LabSamplePrioritySort__c, LastActivityDate, LastModifiedBy.Name, LastModifiedDate, Legacy_Id__c, Name, Number_of_Shingles__c, Observation__c, Owner.Name, Pending_Approval_Date__c, Plant_Feedback_Type__c, PRM__c, Product_Details__c, Received_Date_Brampton__c, Received_Date_Kankakee__c, Recent_Manufacture_Date__c, Sample_Number__c, Sequence_Number__c, Sequence_Prefix__c, Shipping_Date_to_Research_Lab__c, Status__c, SystemModstamp, Technician_Time__c, Test_Generation_Date__c, Time_in_Research__c, Tracking_No_to_Research_Lab__c, Tracking_Number__c, Year__c, (SELECT Case_Closed__c,CreatedDate,Feedback__c,Id,IsDeleted,Lab_Sample__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Manufacture_Date__c,Manufacturing_Info__c,Name,Notes__c,Owner.Name,Producing_Plant__c,Product_Colour__c,Product_Info__c,Product__c,Tape_Code__r.Product__r.Name,Quantity__c,SystemModstamp,Tape_Code_Less_Than_a_Year_Old__c,Tape_Code_Name__c,Tape_Code__c FROM Lab_Sample_Tape_Codes__r ORDER BY Name DESC), (SELECT Case_Closed__c,Id,IsDeleted,Lab_Sample_Approval_Status__c,Lab_Sample__r.Name,Lab_Test__c,Name,Owner.Name,Tape_Code__c,Test_Date__c,Test_Result__c,Test_Status__c, CreatedBy.Name, LastModifiedBy.Name FROM Lab_Test_Results__r ORDER BY Name DESC), (SELECT Case_Number__c,Claim_Number__c,CreatedBy.Name,CreatedDate,Date_Sample_Received_By_Plant__c,Description__c,Id,IsDeleted,Lab_Sample__r.Name,Name,PRM_Approved__c,PRM__c,Product_Code__c,Product_Colour__c,Product_Name__c FROM PRM_Comments__r ORDER BY Name DESC) FROM Lab_Sample__c WHERE Case__c = \'{pv0}\' AND IsDeleted = false ORDER BY Name ASCSC';
        	caseLabSamples.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseLabSamples);

        // Updated April 9, 2020
		APXTConga4__Conga_Merge_Query__c caseOwner = new APXTConga4__Conga_Merge_Query__c();
        	caseOwner.APXTConga4__Name__c = 'Case Summary - Case Owner';
        	caseOwner.APXTConga4__Query__c = 'SELECT Name FROM User WHERE Id = {pv0}';
        	caseOwner.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseOwner);
		
        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c caseSummaryLabTestHistory = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryLabTestHistory.APXTConga4__Name__c = 'Case Summary - Lab Test Results History';
        	caseSummaryLabTestHistory.APXTConga4__Query__c = 'SELECT ParentId, Parent.Name,CreatedBy.Name, CreatedDate, Field, IsDeleted, NewValue, OldValue FROM Lab_Test_Result__History WHERE  ParentId in ({pv0})';
        	caseSummaryLabTestHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryLabTestHistory);
		
        // Update April 9, 2020
        APXTConga4__Conga_Merge_Query__c caseSummaryPRMHistory = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryPRMHistory.APXTConga4__Name__c = 'Case Summary - PRM Comments Approval History';
        	caseSummaryPRMHistory.APXTConga4__Query__c = 'SELECT Id, SubmittedBy.Name,ProcessDefinitionId, ProcessDefinition.Name, ProcessDefinition.Description, ProcessDefinition.Id, (SELECT Id, IsDeleted, LastActorId,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName FROM Nodes ORDER BY ProcessNodeId DESC LIMIT 1), (SELECT Id, StepStatus,Actor.Name, CreatedDate, Comments, ProcessInstanceId FROM StepsAndWorkitems ORDER BY CreatedDate DESC) FROM ProcessInstance WHERE ProcessInstance.TargetObjectId = {pv0} ORDER BY ProcessInstance.CreatedDate DESC';
        	caseSummaryPRMHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryPRMHistory);

        // Updated April 9, 2020
        APXTConga4__Conga_Merge_Query__c caseSummaryTapeCodesHistory = new APXTConga4__Conga_Merge_Query__c();
        	caseSummaryTapeCodesHistory.APXTConga4__Name__c = 'Case Summary - Tape Codes History';
        	caseSummaryTapeCodesHistory.APXTConga4__Query__c = 'SELECT ParentId, Parent.Name,CreatedBy.Name, CreatedDate, Field, IsDeleted, NewValue, OldValue FROM Tape_Code__History WHERE ParentId in ({pv0})';
        	caseSummaryTapeCodesHistory.APXTConga4__Description__c = 'Created by Setup Script';
        queries.add(caseSummaryTapeCodesHistory);
        
        return queries;
    }
 
    // We need some sample Conga templates since we distinguish between English and French
    public static list<APXTConga4__Conga_Template__c> createCongaTemplates() {

        list<APXTConga4__Conga_Template__c> congaTemplates = new list<APXTConga4__Conga_Template__c>();
        
        	APXTConga4__Conga_Template__c english = new APXTConga4__Conga_Template__c();
        		english.APXTConga4__Name__c = 'Sample Conga Template 1';
        		english.Conga_Name_Unique__c = 'Sample Conga English Template';
        		english.Template_Language__c = 'English';
        		english.Template_Status__c = 'Approved';
        		congaTemplates.add(english);
        
        	APXTConga4__Conga_Template__c french = new APXTConga4__Conga_Template__c();
        		french.APXTConga4__Name__c = 'Sample Conga Template 1';
        		french.Conga_Name_Unique__c = 'Sample Conga French Template';
        		french.Template_Language__c = 'French';
        		french.Template_Status__c = 'Approved';
        		congaTemplates.add(french);
        
        
        return congaTemplates;
    }

    public static void customSettingUpdate(){
        System.Debug('Start of Custom Setting Updates. Review debug log.');
        List<APXTConga4__Conga_Merge_Query__c> queries = new List<APXTConga4__Conga_Merge_Query__c>();
        
        queries = [SELECT Id, APXTConga4__Name__c
                   FROM APXTConga4__Conga_Merge_Query__c];
        
        Map<String, APXTConga4__Conga_Merge_Query__c> queriesByName = new Map<String, APXTConga4__Conga_Merge_Query__c>();
        for(APXTConga4__Conga_Merge_Query__c q : queries) {
            queriesByName.put(q.APXTConga4__Name__c, q);
        }
        
        // Create a claims config
        // Claims_Config__c config = new Claims_Config__c();
        
        String congaGenDoc = '&QueryId=[RelatedProduct]' + queriesByName.get('Related Products').Id + ',';
            congaGenDoc += '[Distributor]' + queriesByName.get('Distributor').Id + ',';
            congaGenDoc += '[FullBrand]' + queriesByName.get('Brand Long Name').Id + ',';
            congaGenDoc += '[AltContact]' + queriesByName.get('Alternate Contact (Home Owner)').Id + ',';
            congaGenDoc += '[Condition]' + queriesByName.get('Settlement Conditions').Id + ',';
            congaGenDoc += '[RelatedWarranty]' + queriesByName.get('Diamond Shield Limited Warranty').Id;
        System.Debug('Generate Document ' + congaGenDoc);
        // config.Conga_Gen_Doc_Query__c = congaGenDoc;
        
        String congaWarrantyQuery = '[Contractor]' + queriesByName.get('Warranty - Contractor').Id + ',';
            congaWarrantyQuery += '[Building]' + queriesByName.get('Warranty Certificate - Warranty Owner').Id + ',';
            congaWarrantyQuery += '[Architect]' + queriesByName.get('Warranty Certificate - Architect').Id + ',';
            congaWarrantyQuery += '[RoofingProduct]' + queriesByName.get('Warranty Roofing Products').Id + ',';
            congaWarrantyQuery += '[FlashingProduct]' + queriesByName.get('Warranty Flashing Products').Id;
        System.Debug('Warranty ' + congaWarrantyQuery);
        // config.Conga_Warranty_Query__c = congaWarrantyQuery;
        
        String congaPaymentRequest = '[Case]' + queriesByName.get('Payment Request - Case - New').Id + ',';
            congaPaymentRequest += '[RequestLines]' + queriesByName.get('Payment Request - Payment Request Line - New').Id + ',';
            congaPaymentRequest += '[Customer]' + queriesByName.get('Payment - Account - Contact - Address Info').Id;
        System.Debug('Payment Request ' + congaPaymentRequest);
        // config.Conga_Payment_Request_Query__c = congaPaymentRequest;
        
        String siteInspection = '[Contractor]' + queriesByName.get('Site Inspection Contractor').Id + ',';
			siteInspection = '[Inspector]' + queriesByName.get('Site Inspection Inspector').Id + ',';
            siteInspection += '[Building]' + queriesByName.get('Site Inspection Building').Id + ',';
			siteInspection += '[RoofingSystem]' + queriesByName.get('Roofing System Warranty').Id + ',';
            siteInspection += '[InspectorContact]' + queriesByName.get('Site Inspection Contractor Contact').Id + ',';
			siteInspection += '[ContractorContact]' + queriesByName.get('Site Inspection Contractor Contact').Id + ',';
			siteInspection += '[Sharinpix]' + queriesByName.get('Site Inspection Sharinpix').Id;
        System.Debug('Site Inspection ' + siteInspection);
        
        String congaCaseSummaryQueries = '[AlternateContact]' + queriesByName.get('Case Summary - Alternate Contact').Id + '?pv0={!Case.Alternate_Contact_Id__c},';
            congaCaseSummaryQueries += '[LabSampleHistory]' + queriesByName.get('Case Summary - Lab Sample History').Id + '?pv0={QVar0},';
            congaCaseSummaryQueries += '[RelatedCases]' + queriesByName.get('Case Summary - Related Cases').Id + ',';
            congaCaseSummaryQueries += '[PaymentReqHistory]' + queriesByName.get('Case Summary - Payment Request History').Id + '?pv0={QVar1},';
            congaCaseSummaryQueries += '[LabSampleApprovals]' + queriesByName.get('Case Summary - Lab Sample Approval History').Id + '?pv0={QVar0},';
            congaCaseSummaryQueries += '[CaseRecordType]' + queriesByName.get('Case Summary - Record Type').Id + '?pv0={!Case.RecordTypeId},';
            congaCaseSummaryQueries += '[CaseFeed]' + queriesByName.get('Case Summary - Case Feed').Id + ',';
            congaCaseSummaryQueries += '[CaseProducts]' + queriesByName.get('Case Summary - Case Products').Id + ',';
            congaCaseSummaryQueries += '[CaseComments]' + queriesByName.get('Case Summary - Case Comments').Id + ',';
            congaCaseSummaryQueries += '[CaseHistory]' + queriesByName.get('Case Summary - Case History').Id + ',';
            congaCaseSummaryQueries += '[Warranty]' + queriesByName.get('Case Summary - Warranty').Id + '?pv0={!Case.WarrantyId__c},';
            congaCaseSummaryQueries += '[ApprovalHistory]' + queriesByName.get('Case Summary - Approval History').Id + ',';
            congaCaseSummaryQueries += '[PaymentRequests]' + queriesByName.get('Case Summary - Payment Requests').Id + ',';
            congaCaseSummaryQueries += '[SettlementConditions]' + queriesByName.get('Case Summary - Settlement Conditions').Id + ',';
            congaCaseSummaryQueries += '[ClaimTypes]' + queriesByName.get('Case Summary - Claim Types').Id + ',';
            congaCaseSummaryQueries += '[LabSamples]' + queriesByName.get('Case Summary - Lab Samples').Id + ',';
            congaCaseSummaryQueries += '[CaseOwner]' + queriesByName.get('Case Summary - Case Owner').Id + ',';
            congaCaseSummaryQueries += '[LabTstResHist]' + queriesByName.get('Case Summary - Lab Test Results History').Id + '?pv0={QVar3},';
            congaCaseSummaryQueries += '[LabPRMComApHist]' + queriesByName.get('Case Summary - PRM Comments Approval History').Id + '?pv0={QVar4},';
            congaCaseSummaryQueries += '[TapeCodesHist]' + queriesByName.get('Case Summary - Tape Codes History').Id + '?pv0={QVar5}';
        System.Debug('Case Summary: ' + congaCaseSummaryQueries);
        // config.Case_Summary_Queries__c = congaCaseSummaryQueries;

        // insert config;
        
        System.Debug('End of Custom Setting Updates. Review debug log.');

    }
    
}