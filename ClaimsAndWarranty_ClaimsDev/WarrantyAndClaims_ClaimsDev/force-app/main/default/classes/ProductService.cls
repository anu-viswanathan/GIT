public with sharing class ProductService {
	
    public static void updateEngFreFullDescriptionforUnitOfMeasure(List<Product2> records) {
        for (Product2 p : records) {
            switch on p.Unit_of_Measure__c {
                when 'BD' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Bundles';
                    p.Unit_of_Measure_French_Description__c= 'Paquets';
                }   
                when 'BG' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Bags';
                    p.Unit_of_Measure_French_Description__c = 'Sacs';
                }  
                when 'BX' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Boxes';
                    p.Unit_of_Measure_French_Description__c = 'Boites';
                }  
                when 'CS' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Case';
                    p.Unit_of_Measure_French_Description__c = 'Cas';
                } 
                when 'DR' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Drum';
                    p.Unit_of_Measure_French_Description__c= 'Bidon';
                } 
                when 'EA' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Each';
                    p.Unit_of_Measure_French_Description__c= 'Chaque';
                } 
                when 'FT' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Feet Linear';
                    p.Unit_of_Measure_French_Description__c = 'Pieds linéaires';
                } 
                when 'GA' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Gallons';
                    p.Unit_of_Measure_French_Description__c = 'Gallons';
                } 
                when 'GL' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Gallon(s)';
                    p.Unit_of_Measure_French_Description__c = 'Gallons';
                } 
                when 'KE' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Kegs';
                    p.Unit_of_Measure_French_Description__c= 'Baril';
                } 
                when 'KT' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Kits';
                    p.Unit_of_Measure_French_Description__c= 'Trousse';
                } 
                when 'LB' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Pounds';
                    p.Unit_of_Measure_French_Description__c = 'Poids';
                } 
                when 'PA' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Pallets';
                    p.Unit_of_Measure_French_Description__c = 'Palettes';
                } 
                when 'PL' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Pail';
                    p.Unit_of_Measure_French_Description__c = 'Seau';
                } 
                when 'QT' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Quart';
                    p.Unit_of_Measure_French_Description__c = 'Litre';
                }
                when 'RL' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Rolls';
                    p.Unit_of_Measure_French_Description__c = 'Rouleaux';
                }
                when 'SF' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Square Feet';
                    p.Unit_of_Measure_French_Description__c = 'Pieds Carrés';
                }
                when 'SH' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Sheets';
                    p.Unit_of_Measure_French_Description__c = 'Feuilles';
                }
                when 'SQ' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Square';
                    p.Unit_of_Measure_French_Description__c = 'Carré';
                }
                when 'T' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Metric Tonne';
                    p.Unit_of_Measure_French_Description__c = 'Tonne métrique';
                }
                when 'TB' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Tube';
                    p.Unit_of_Measure_French_Description__c = 'Tube';
                }
                when 'YD' {       // when block 1
                    p.Unit_of_Measure_Description__c = 'Yard';
                    p.Unit_of_Measure_French_Description__c = 'Yard';
                }
                when else {       // when else block, optional
                    p.Unit_of_Measure_Description__c = p.Unit_of_Measure__c;
                }
			}
        }
    }
    
    

}