global class icBatchOrderDataMigration implements Database.Batchable <sObject>, Database.Stateful
{
    Map <Id, Account > mapAllAccounts = new Map <Id, Account > ();
    Map<String, List<Order>> mapOrdersByAccount = new Map<String, List<Order>>();
    icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');
    icLogicOrder.IClass logicOrder = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');
    Boolean isUpdateOrders = false;
    String emailToSendrecipient;

    global icBatchOrderDataMigration(Boolean isUpdateOrders, String emailToSendrecipient) {
        this.isUpdateOrders = isUpdateOrders;
        this.emailToSendrecipient = emailToSendrecipient;
    }

    global icBatchOrderDataMigration() {
        this.isUpdateOrders = true;
        this.emailToSendrecipient = 'Priyanthi.Fernando@iko.com';
    }

    global Database.QueryLocator start (Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, AccountId, Customer_Number_Mapics__c, OrderNumber FROM Order' +
            ' WHERE Account.Mapics_ERP_Id__c LIKE \'99999999%\''
        );
    }

    global void execute( Database.BatchableContext bc, List<Order> scope) {

        Set<String> customerNumberMapics = new Set<String>();
        for( Order orderObj : scope) {
            if (orderObj.Customer_Number_Mapics__c != null) {
                customerNumberMapics.add(orderObj.Customer_Number_Mapics__c);

            }
        }

        List <Account> accounts = logicAccount.getAccountsByMapicsExternalId(customerNumberMapics);
        List<Order> ordersToUpdate = new List<Order>();
        Map <String, List<Order>> mapOrdersByAccountMapics = logicOrder.getOrdersByMapicIdsMap(scope);
    
        
        for (Account thisAccount :accounts) {

            if(!mapAllAccounts.containsKey(thisAccount.Id)){
                mapAllAccounts.put(thisAccount.Id, thisAccount);
            }
            
            List<Order> listOrders = mapOrdersByAccountMapics.get(thisAccount.Mapics_ERP_Id__c);

            if(listOrders != null){
                
                for(Order thisOrder : listOrders){
                    thisOrder.AccountId = thisAccount.Id;
                }
                ordersToUpdate.addAll(listOrders);

                List<Order> ordersToAdd = mapOrdersByAccount.get(thisAccount.Id);
                
                if(ordersToAdd == null){
                    ordersToAdd = new List<Order>();
                }
                ordersToAdd.addAll(listOrders);
                
                mapOrdersByAccount.put(thisAccount.Id, ordersToAdd);
                
            }
            
        }

        if(isUpdateOrders){
            logicOrder.updateOrders(ordersToUpdate);
        }

    }

    public void finish(Database.BatchableContext bc) {
        String emailBodyHTML = 'Order Data Migration Process ran and completed at : ' + Datetime.now() + ' <br><br>';
        emailBodyHTML += '<br> Total accounts processed : ' + mapAllAccounts.size() + ' <br><br>';
    
        for(Account thisAccount : mapAllAccounts.values()){
            
            List<Order> orders = mapOrdersByAccount.get(thisAccount.Id);
            emailBodyHTML += thisAccount.Name + '(' + thisAccount.Mapics_ERP_Id__c +') : '+ orders.size() +' Order <br/>'; 

            integer idx = 1;
            for(Order thisOrder : orders){
                emailBodyHTML +=  (' &nbsp;&nbsp;&nbsp;&nbsp;  Order '+ idx +'  -  ' + thisOrder.OrderNumber + '<br/>');
                idx++;
            }
            emailBodyHTML += '<br/>';
            
        }

		Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage(); 

		emailOut.setSubject('Order Data Migration Process Results');
		emailOut.setSenderDisplayName('Automated Process');
		emailOut.setToAddresses(new String[] {emailToSendrecipient});
		emailOut.setHTMLBody(emailBodyHTML);        

        Messaging.sendEmail(new List<Messaging.Email>{emailOut});
    }
}