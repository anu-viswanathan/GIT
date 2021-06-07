/**
 * Created by Francois Poirier on 2019-11-13.
 */

public with sharing class icDtoGetTokenResponse {

    public Integer status {get;set;}
    public String requestMethod {get;set;}
    public String token {get; set;}
    public String errMsg {get;set;}

}