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
    
    private static void CreateProductsWithDifferentUOM()
    {
        List<Product2> lstProduct = new List<Product2>();
        
        Product2 p1 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct1'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'BD'
            );
        lstProduct.add(p1);
                
        Product2 p2 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct2'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'BG'
            );
        lstProduct.add(p2);
        
        Product2 p3 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct1'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'BX'
            );
        lstProduct.add(p3);
        Product2 p4 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct4'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'CS'
            );
        lstProduct.add(p4);
        Product2 p5 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct5'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'DR'
            );
        lstProduct.add(p5);
        Product2 p6 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct6'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'FT'
            );
        lstProduct.add(p6);
        Product2 p7 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct7'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'GA'
            );
        lstProduct.add(p7);
        Product2 p8 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct8'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'GL'
            );
        lstProduct.add(p8);
        Product2 p9 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct9'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'KE'
            );
        lstProduct.add(p9);
        Product2 p10 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct10'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'KT'
            );
        lstProduct.add(p10);
        Product2 p11 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct11'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'LB'
            );
        lstProduct.add(p11);
        Product2 p12 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct12'
        	,ProductCode = 'IkoSampleProduct' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'PA'
            );
        lstProduct.add(p12);
        Product2 p13 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct13'
        	,ProductCode = 'IkoSampleProduct13' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'QT'
            );
        lstProduct.add(p13);
        Product2 p14 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct14'
        	,ProductCode = 'IkoSampleProduct14' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'RL'
            );
        lstProduct.add(p14);
        Product2 p15 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct15'
        	,ProductCode = 'IkoSampleProduct15' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'SF'
            );
        lstProduct.add(p15);
        Product2 p16 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct16'
        	,ProductCode = 'IkoSampleProduct16' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'SH'
            );
        lstProduct.add(p16);
        Product2 p17 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct17'
        	,ProductCode = 'IkoSampleProduc17t' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'SQ'
            );
        lstProduct.add(p17);
        Product2 p18 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct18'
        	,ProductCode = 'IkoSampleProduct18' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'T'
            );
        lstProduct.add(p18);
        Product2 p19 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct19'
        	,ProductCode = 'IkoSampleProduct19' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'TB'
            );
        lstProduct.add(p19);
        Product2 p20 = new Product2(
        	Iko_Product_Family__c = 'IkoSampleProduct'
        	,IsActive = true 
        	,Name = 'IkoSampleProduct20'
        	,ProductCode = 'IkoSampleProduct20' 
        	,Sectors__c = 'US;CA;Commercial;Blair'
        	,Unit_of_Measure__c = 'YD'
            );
        lstProduct.add(p20);
        insert(lstProduct);
    }
    
    @isTest static void testFullDescriptionForUnitOfMeasure(){
        CreateProductsWithDifferentUOM();
        List<Product2> lstProductAdded = [SELECT Unit_of_Measure__c,Unit_of_Measure_Description__c, Unit_of_Measure_French_Description__c FROM Product2 WHERE Name like 'IkoSampleProduct%'];
        for (Product2 p : lstProductAdded)
        {
            switch on p.Unit_of_Measure__c {
                when 'BD' {       // when block 1
                    System.assertEquals('Bundles',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Paquets',p.Unit_of_Measure_French_Description__c);
                }   
                when 'BG' {       // when block 1
                    System.assertEquals('Bags',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Sacs',p.Unit_of_Measure_French_Description__c);
                }  
                when 'BX' {       // when block 1
                    System.assertEquals('Boxes',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Boites',p.Unit_of_Measure_French_Description__c);
                }  
                when 'CS' {       // when block 1
                    System.assertEquals('Case',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Cas',p.Unit_of_Measure_French_Description__c);
                } 
                when 'DR' {       // when block 1
                    System.assertEquals('Drum',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Bidon',p.Unit_of_Measure_French_Description__c);
                } 
                when 'FT' {       // when block 1
                    System.assertEquals('Feet Linear',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Pieds linéaires',p.Unit_of_Measure_French_Description__c);
                } 
                when 'GA' {       // when block 1
                    System.assertEquals('Gallons',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Gallons',p.Unit_of_Measure_French_Description__c);
                } 
                when 'GL' {       // when block 1
                    System.assertEquals('Gallon(s)',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Gallons',p.Unit_of_Measure_French_Description__c);
                } 
                when 'KE' {       // when block 1
                    System.assertEquals('Kegs',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Baril',p.Unit_of_Measure_French_Description__c);
                } 
                when 'KT' {       // when block 1
                    System.assertEquals('Kits',p.Unit_of_Measure_Description__c);
                } 
                when 'LB' {       // when block 1
                    System.assertEquals('Pounds',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Poids',p.Unit_of_Measure_French_Description__c);
                   } 
                when 'PA' {       // when block 1
                    System.assertEquals('Pallets',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Palettes',p.Unit_of_Measure_French_Description__c);
                   } 
                when 'QT' {       // when block 1
                    System.assertEquals('Quart',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Litre',p.Unit_of_Measure_French_Description__c);
                }
                when 'RL' {       // when block 1
                    System.assertEquals('Rolls',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Rouleaux',p.Unit_of_Measure_French_Description__c);
                }
                when 'SF' {       // when block 1
                    System.assertEquals('Square Feet',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Pieds Carrés',p.Unit_of_Measure_French_Description__c);
                 }
                when 'SH' {       // when block 1
                    System.assertEquals('Sheets',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Feuilles',p.Unit_of_Measure_French_Description__c);
                }
                when 'SQ' {       // when block 1
                    System.assertEquals('Square',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Carré',p.Unit_of_Measure_French_Description__c);
                }
                when 'T' {       // when block 1
                    System.assertEquals('Metric Tonne',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Tonne métrique',p.Unit_of_Measure_French_Description__c);
               }
                when 'TB' {       // when block 1
                    System.assertEquals('Tube',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Tube',p.Unit_of_Measure_French_Description__c);
               }
                when 'YD' {       // when block 1
                    System.assertEquals('Yard',p.Unit_of_Measure_Description__c);
                    System.assertEquals('Yard',p.Unit_of_Measure_French_Description__c);
                }
                when else {       // when else block, optional
                    System.assertEquals(p.Unit_of_Measure__c,p.Unit_of_Measure_Description__c);
                    System.assertEquals(p.Unit_of_Measure__c,p.Unit_of_Measure_French_Description__c);
               }
            }
       	}
    }
 
}