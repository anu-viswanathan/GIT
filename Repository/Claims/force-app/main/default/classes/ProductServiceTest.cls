/**
 * Created by janet.john on 8/27/2019.
 */
@isTest
public with sharing class ProductServiceTest {

    @TestSetup
    private static void setup() {


        //create products
        List<Product2> toInsertProducts = new List<Product2>();

        toInsertProducts.addAll(TestFactory.createProducts('GoodTestRoofer',TRUE,null,'CA;US;Commercial','Commercial',1,false));

        insert toInsertProducts;

    }

    private static testMethod void populateProductSectors_populateSectorsFieldFromMultiSelectOnInsert_SectorFieldPopulatedFromSectorsMultiSelect(){

        List<Product2> actualProducts = new List<Product2>([SELECT Id,Name,Sectors_Text__c,Sectors__c FROM Product2 WHERE Name = 'GoodTestRoofer']);

        Test.startTest();
        try{
            insert actualProducts;
        }catch(Exception e){

        }
        Test.stopTest();

        List<Product2> expectedProducts = [SELECT Id,Name,Sectors_Text__c,Sectors__c FROM Product2 WHERE Name = 'GoodTestRoofer'];

        //Assert
        System.assertEquals(expectedProducts[0].Sectors_Text__c,actualProducts[0].Sectors__c);
    }

    private static testMethod void populateProductSectors_populateSectorsFieldFromMultiSelectOnUpdate_SectorFieldPopulatedFromSectorsMultiSelect(){

        List<Product2> actualProducts = new List<Product2>([SELECT Id,Name,Sectors_Text__c,Sectors__c FROM Product2 WHERE Name = 'GoodTestRoofer']);

        Test.startTest();
        try{
            update actualProducts;
        }catch(Exception e){

        }
        Test.stopTest();

        List<Product2> expectedProducts = [SELECT Id,Name,Sectors_Text__c,Sectors__c FROM Product2 WHERE Name = 'GoodTestRoofer'];

        //Assert
        System.assertEquals(expectedProducts[0].Sectors_Text__c,actualProducts[0].Sectors__c);
    }
}