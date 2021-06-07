@isTest
global class icTestHttpResponseMock implements HttpCalloutMock {
    List<HttpResponse> listResponses = new List<HttpResponse>();

    global void addResponse(String responseStatus, Integer responseCode, String responseBody) {
        HttpResponse response = new HttpResponse();
        response.setStatus(responseStatus);
        response.setStatusCode(responseCode);
        response.setBody(responseBody);
        listResponses.add(response);
    }

    global void addResponse(HttpResponse response) {
        listResponses.add(response);
    }

    global HttpResponse respond(HttpRequest request) {
        return listResponses.remove(0);
    }

}