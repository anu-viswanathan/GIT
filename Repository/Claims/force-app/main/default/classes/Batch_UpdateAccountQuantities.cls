/*
TO RUN

Batch_UpdateAccountQuantities foo = new Batch_UpdateAccountQuantities();
Id batchId = Database.executeBatch(foo, 10);

This is called after the UpdateAccountStatistics method is finished
*/

global class Batch_UpdateAccountQuantities implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        // Create a set of test accounts. Comment this out in production
        // add more accounts here if you want a larger test set
/*
        Set<Id> testAccounts = new Set<Id>();
        	testAccounts.add('0011R00001zo4gxQAA');
        	testAccounts.add('0013600001K6GPHAA3');
        	testAccounts.add('0013600001K6GPpAAN');
        	testAccounts.add('0013600001K6GQpAAN');
*/                
        String q;
        q = 'SELECT Id, Name ';
        q += 'FROM Account ';
        q += 'WHERE Mapics_ERP_Id__c != null ';
        q += 'AND Mapics_ERP_Id__c != \'99999999\' ';
//        q += 'AND Id IN :testAccounts ';
        
        // Comment out the next line to INCLUDE the "bulk" accounts
        // q += 'AND (NOT Mapics_ERP_Id__c LIKE \'99999999-%\') ';

        q += 'ORDER BY Name ASC';
		// System.Debug(q);
        
        System.Debug(Database.getQueryLocator( q ));
        
        return Database.getQueryLocator( q );
    }

        
    global void execute(Database.BatchableContext bc, List<Account> scope){
		System.Debug('Size of List ' + scope.size());

        Set<Id> allAccountIds = new Set<Id>();
        for(Account a : scope) {
            allAccountIds.add(a.Id);
        }
        
        // 2020-01-13 Query has been modified to produce a different result
        // On January 1 we have no data for December but we want our YTD data to show December's data
        // This is wrong. But anyway.
        DateTime queryStartDate;
        DateTime queryEndDate;
        Integer effectiveCurrentYear;
        Integer effectivePreviousYear;
        Integer effectiveCurrentMonth;
        Integer effectivePreviousMonth;
        Integer effectiveCurrentDayofYear; // This needs to be the last day of the previous year if it's january
        								   // This allows us to accomodate a future where we get DAILY DATA
        
        if(System.Today().month() == 1) {
            // If it's January the current year is last year and the previous year is two years ago
            // We also need to store an effective current year because...well
            queryStartDate = DateTime.NewInstance(System.today().year(), 1, 1).addYears(-2);
            queryEndDate = DateTime.NewInstance(System.today().year(), 12, 31).addYears(-1);
            effectiveCurrentYear = System.today().year() - 1;
            effectivePreviousYear = System.today().year() - 2;
            effectiveCurrentDayofYear = System.today().toStartOfMonth().addDays(-1).dayOfYear();
//            effectiveCurrentMonth = System.today().addMonths(-1).month();
//            effectivePreviousMonth = System.today().addMonths(-2).month();
        } else {
            // If it's not January, the current year is the current year and the previous
            // year is the previous year
            queryStartDate = date.NewInstance(System.today().year(), 1, 1).addYears(-1);
            queryEndDate = date.NewInstance(System.today().year(), 12, 31);
            effectiveCurrentYear = System.today().year();
            effectivePreviousYear = System.today().year() - 1;
            effectiveCurrentDayofYear = System.Today().dayOfYear();
       }

        // We never have this month's data, so our effective current month is always -1 from today
        effectiveCurrentMonth = System.today().addMonths(-1).month();
		effectivePreviousMonth = System.today().addMonths(-2).month();

        System.Debug(queryStartDate + ' - ' + queryEndDate);
        
		String orderQuery;
        orderQuery = 'SELECT Id, AccountId, Account.Name, EffectiveDate, Amount_MAPICS__c, Shipped_Quantity_MAPICS__c, Unit_of_Measure__c ';
        	orderQuery += 'FROM Order ';
        	orderQuery += 'WHERE EffectiveDate >= '; 
            orderQuery += queryStartDate.format('yyyy-MM-dd');
        	orderQuery += ' AND EffectiveDate <= ';
            orderQuery += queryEndDate.format('yyyy-MM-dd');
        	orderQuery += ' AND AccountId IN :allAccountIds ';
        	orderQuery += 'AND Shipped_Quantity_MAPICS__c != null ';
        	orderQuery += 'ORDER BY Account.Name ASC';
System.Debug(orderQuery);

        List<Order> allOrders = Database.query(orderQuery);
        // List<Order> allOrders = new List<Order>(orderQuery);
        System.Debug(allOrders);

		// Create two lists and split the orders into previous year of current year
		// Our query is this year or last year, so we can just do the ELSE  
        List<Order> previousYearOrders = new List<Order>(); 
        List<Order> currentYearOrders = new List<Order>(); 
        List<Order> previousMonthOrders  = new List<Order>(); 
        List<Order> previousMonthLastYearOrders = new List<Order>(); 

        for (Order o : allOrders) {

                recordsProcessed += 1;
                
                if(o.EffectiveDate.year() == effectiveCurrentYear) {
                    currentYearOrders.add(o);
                    if(o.EffectiveDate.month() == effectiveCurrentMonth) { 
                        previousMonthOrders.add(o); 
                        }
                } else {
                    previousYearOrders.add(o);
                    if(o.EffectiveDate.month() == effectiveCurrentMonth) { 
                        previousMonthLastYearOrders.add(o); 
                        }
                }
            }

        
        System.Debug(previousYearOrders.size());
        System.Debug(currentYearOrders.size());
        System.Debug(previousMonthOrders.size());
        System.Debug(previousMonthLastYearOrders.size());

        // Maps are unique, so we're going to use maps to create the sums
        // Three maps, one for each of the numbers we're trying to determine
        // Then at the end we combine them into one
		Map<Id, Decimal> previousYearFullbyAccountID = new Map<Id, Decimal>();
		Map<Id, Decimal> previousYearYTDbyAccountID = new Map<Id, Decimal>();
		Map<Id, Decimal> currentYearYTDbyAccountID = new Map<Id, Decimal>();
        Map<Id, Decimal> currentYearPreviousMonth = new Map<Id, Decimal>();
        Map<Id, Decimal> previousYearPreviousMonth = new Map<Id, Decimal>();
        
        for(Order o : previousYearOrders) {
            if(previousYearFullbyAccountID.containsKey(o.AccountId) == false) {
				
                previousYearFullbyAccountID.put(o.AccountId, o.Shipped_Quantity_MAPICS__c);
                
				// Determines if YTD
                if(o.EffectiveDate.dayOfYear() < effectiveCurrentDayOfYear) { 
                    previousYearYTDbyAccountID.put(o.AccountId, o.Shipped_Quantity_MAPICS__c);

                } else { previousYearYTDbyAccountID.put(o.AccountId, 0); }
            } else {

                previousYearFullbyAccountID.put(o.AccountId, o.Shipped_Quantity_MAPICS__c + previousYearFullbyAccountID.get(o.AccountId));

                // Previous year to date values
                if(o.EffectiveDate.dayOfYear() < effectiveCurrentDayOfYear) { 
                    previousYearYTDbyAccountID.put(o.AccountId, o.Shipped_Quantity_MAPICS__c + previousYearYTDbyAccountID.get(o.AccountId)); 
                }

            }
        }
        
        System.Debug(previousYearFullbyAccountID);
        System.Debug(previousYearYTDbyAccountID);
        
        // Calculate the current year which is slightly easier because we don't have to accomodate "YTD logic. Yeah!"
        for(Order o : currentYearOrders) {
            if(currentYearYTDbyAccountID.containsKey(o.AccountId) == false) {
                currentYearYTDbyAccountID.put(o.AccountId, o.Shipped_Quantity_MAPICS__c);
            } else {
				currentYearYTDbyAccountID.put(o.AccountId, o.Shipped_Quantity_MAPICS__c + currentYearYTDbyAccountID.get(o.AccountId));
            }
        }
		
        // Previous Month of the Current Year
        for(Order o : previousMonthOrders) {
            if(currentYearPreviousMonth.containsKey(o.AccountId) == false) {
                currentYearPreviousMonth.put(o.AccountId, o.Shipped_Quantity_MAPICS__c);
            } else {
				currentYearPreviousMonth.put(o.AccountId, o.Shipped_Quantity_MAPICS__c + currentYearPreviousMonth.get(o.AccountId));
            }
        }

        // Previous Month of the Previous Year
        for(Order o : previousMonthLastYearOrders) {
            if(previousYearPreviousMonth.containsKey(o.AccountId) == false) {
                previousYearPreviousMonth.put(o.AccountId, o.Shipped_Quantity_MAPICS__c);
            } else {
				previousYearPreviousMonth.put(o.AccountId, o.Shipped_Quantity_MAPICS__c + previousYearPreviousMonth.get(o.AccountId));
            }
        }
        
        List<Account> accounts = new List<Account>();
        for(Account acc : scope) {
            Account a = new Account();
            	a.Id = acc.Id;
            	if(previousYearFullbyAccountID.containsKey(a.Id)) { a.Order_Summary_Quantity_Previous_Year__c = previousYearFullbyAccountID.get(a.Id); }
            	if(previousYearYTDbyAccountID.containsKey(a.Id)) { a.Previous_Year_YTD_Quantity__c = previousYearYTDbyAccountID.get(a.Id); }
            	if(currentYearYTDbyAccountID.containsKey(a.Id)) { a.YTD_Quantity__c = currentYearYTDbyAccountID.get(a.Id); }

               	// Monthly fields
            	if(currentYearPreviousMonth.containsKey(a.Id)) { a.Order_Summary_Last_Month_Qty__c = currentYearPreviousMonth.get(a.Id); }
            	if(previousYearPreviousMonth.containsKey(a.Id)) { a.Order_Summary_Last_Month_Year_Qty__c = previousYearPreviousMonth.get(a.Id); }

            accounts.add(a);
        }
        
        update accounts;
	}
        
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed by Batch_UpdateAccountQuantities!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        // EmailUtils.sendMessage(job, recordsProcessed);

        Database.executeBatch(new Batch_UpdateAccountBundles());

    }    
}