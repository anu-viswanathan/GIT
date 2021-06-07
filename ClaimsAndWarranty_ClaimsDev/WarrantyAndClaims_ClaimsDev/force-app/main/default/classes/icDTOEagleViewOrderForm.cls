public with sharing class icDTOEagleViewOrderForm {	
    public String streetAddress {get;set;}
    public String city {get;set;}
    public String state {get;set;}
    public String postalCode {get;set;}
    public String country {get;set;}
    public Integer propertyType {get;set;}
    public icDTOEagleViewProduct product {get;set;}
    public icDTOEagleViewProduct delivery {get;set;}
    public Integer measurementType {get;set;}
    public String specialInstructions {get;set;}
    public Boolean changesInLast4Years {get;set;}

}