/**
 * Created by Francois Poirier on 2018-06-20.
 */

public with sharing class icDTOEagleViewOrderReport {

    public List<icDTOEagleViewReportAddress> ReportAddresses {get;set;}
    public Integer PrimaryProductId {get;set;}
    public Integer DeliveryProductId {get;set;}
    public Integer MeasurementInstructionType {get;set;}
    public Boolean ChangesInLast4Years {get;set;}

}