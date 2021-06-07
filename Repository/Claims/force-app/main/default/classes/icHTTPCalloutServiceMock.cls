/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icHTTPCalloutServiceMock implements HttpCalloutMock{

    public HTTPResponse respond(HTTPRequest req) {

        if(req.getEndpoint().endsWith('Merchant')) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"isValid": true,"token": "0xeaff177626d8217a606bad4fabbdbd8cd1da9dd5","merchantName": "Test Merchant Name","creditProduct": "Installment","applicationFlow": "short","program": "GreenSky Consumer Projects","affected": false}');
            res.setStatusCode(200);
            return res;
        }

        if(req.getEndpoint().endsWith('asynchronoussubmit')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"applicantFirstName": "JOHN","applicantLastName": "BARKER","applicantDateOfBirth": "09/01/1933","applicantMarried": "false","applicantPhoneNumber": "123-123-1234","applicantStreetNumber": "505","applicantStreetAddress": "505 MOUNTAIN HILL RD","applicantCity": "FORTSON","applicantState": "GA","applicantZipCode": "31808","applicantEmailAddress": "francois.poirier@in-cloud.ca","applicantEmployerName": "Global Employer","applicantYearsOnJob": "10","applicantSSN": "666-06-0774","applicantGrossIncome": 100000.00,"contractLanguage": "English","requestedLoanAmount": 5000.00,"coApplicantIndicator": "false","program": "GreenSky Consumer Projects","product": "Installment","role": "Merchant","promotionCode": "","referral": "81006534-9999","channel": "External-API-IKO"}');
            res.setStatusCode(200);
            return res;
        }

        if(req.getEndpoint().contains('&role=')){

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"applicantFirstName": "JOHN","applicantLastName": "BARKER","applicantDateOfBirth": "09/01/1933","applicantMarried": "false","applicantPhoneNumber": "123-123-1234","applicantStreetNumber": "505","applicantStreetAddress": "505 MOUNTAIN HILL RD","applicantCity": "FORTSON","applicantState": "GA","applicantZipCode": "31808","applicantEmailAddress": "francois.poirier@in-cloud.ca","applicantEmployerName": "Global Employer","applicantYearsOnJob": "10","applicantSSN": "666-06-0774","applicantGrossIncome": 100000.00,"contractLanguage": "English","requestedLoanAmount": 5000.00,"coApplicantIndicator": "false","program": "GreenSky Consumer Projects","product": "Installment","role": "Merchant","promotionCode": "","referral": "81006534-9999","channel": "External-API-IKO"}');
        res.setStatusCode(200);
            return res;
        }

        if(req.getEndpoint().contains('decision')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"applicantFullName": "LANDAU ALLEN","requestedLoanAmount": "1300.0000","status": "Under Review"}');
            res.setStatusCode(200);
            return res;
        }

        if(req.getEndpoint().contains('offer')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"applicantFullName": "LANDAU ALLEN","date": "04/20/2017","applicationStatus": "Authorized","planNumber": "9999","paymentTermOfferMessage": "* Final Loan Amount (Amount Financed) and Monthly Payment will be based on total amount purchased within the Credit Limit. To modify your Loan Amount, enter the New Loan Amount in the space below, then click “Calculate Terms”.","offers": [{"apr": 17.99000,"id": "131783","loanAmount": 20000.0000,"monthlyPayment": 433.6900,"promotionDetails": "Plan 9999. 84 month loan. 5 month initial period beginning at approval with up to 5 interest only payments (number of interest only payments depends on date of 1st transaction) followed by 79 amortized payments based on the balance at the end of the initial period. No prepayment penalty. APR stated in your loan agreement is fixed for the life of the loan.","term": 79,"creditProduct": "Installment","secondLook": 0,"planNumber": "9999", "promotionPeriod": 5, "isDeferred": false},{"apr": 17.99000,"id": "131783","loanAmount": 20000.0000,"monthlyPayment": 433.6900,"promotionDetails": "Plan 9999. 84 month loan. 5 month initial period beginning at approval with up to 5 interest only payments (number of interest only payments depends on date of 1st transaction) followed by 79 amortized payments based on the balance at the end of the initial period. No prepayment penalty. APR stated in your loan agreement is fixed for the life of the loan.","term": 79,"creditProduct": "Installment","secondLook": 0,"planNumber": "1187", "promotionPeriod": 5, "isDeferred": false}]}');
            res.setStatusCode(200);
            return res;
        }
        if(req.getEndpoint().contains('loanagreement')){

                HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"applicantFullName": "LANDAU ALLEN","applicantEmail": "awer@fsdfsdf.com","lender": "Regions Bank, an Alabama banking corporation","amountFinanced": 10000,"apr": 17.99,"term": "79","monthlyPayment": 433.69,"promotionDetails": "Plan 9999. 84 month loan. 5 month initial period beginning at approval with up to 5 interest only payments (number of interest only payments depends on date of 1st transaction) followed by 79 amortized payments based on the balance at the end of the initial period. No prepayment penalty. APR stated in your loan agreement is fixed for the life of the loan.","creditProduct": "Installment"}');
            res.setStatusCode(200);
            return res;
        }
        if(req.getEndpoint().contains('email')){

                HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
        if(req.getEndpoint().contains('/list')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"lists":[{"name":"state","values":["A"]},{"name":"typeOfId","values":["B"]},{"name":"youAre","values":["C"]}]}');
            res.setStatusCode(200);
            return res;
        }
        if(req.getEndpoint().contains('GetAvailableProducts')){

                HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"productID":31,"name":"Premium - Residential","description":"Premium","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":30.0000,"priceMax":75.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000},{"productID":4,"name":"Express","description":"Express Delivery","isTemporarilyUnavailable":false,"priceMin":30.0000,"priceMax":30.0000},{"productID":7,"name":"3 Hour","description":"Three Hour Delivery","isTemporarilyUnavailable":false,"priceMin":40.0000,"priceMax":40.0000}],"addOnProducts":[{"productID":33,"name":"Walls","description":"Walls","isTemporarilyUnavailable":false,"priceMin":70.0000,"priceMax":70.0000}],"measurementInstructionTypes":[1,2,3,4,5],"TypeOfStructure":1,"IsRoofProduct":true,"SortOrder":1,"AllowsUserSubmittedPhotos":true},{"productID":11,"name":"SunSite - Residential","description":"SunSite™","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":35.0000,"priceMax":80.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000},{"productID":4,"name":"Express","description":"Express Delivery","isTemporarilyUnavailable":false,"priceMin":30.0000,"priceMax":30.0000},{"productID":7,"name":"3 Hour","description":"Three Hour Delivery","isTemporarilyUnavailable":false,"priceMin":40.0000,"priceMax":40.0000}],"addOnProducts":[],"measurementInstructionTypes":[1,2,3,4,5],"TypeOfStructure":1,"IsRoofProduct":true,"SortOrder":5,"AllowsUserSubmittedPhotos":true},{"productID":34,"name":"Residential - Walls Only","description":"Walls","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":70.0000,"priceMax":70.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000}],"addOnProducts":[],"measurementInstructionTypes":[1,2,3,4,5],"TypeOfStructure":1,"IsRoofProduct":false,"SortOrder":34,"AllowsUserSubmittedPhotos":true},{"productID":44,"name":"QuickSquares - Residential","description":"QuickSquares™","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":18.0000,"priceMax":18.0000,"deliveryProducts":[{"productID":45,"name":"Quick","description":"Quick Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000}],"addOnProducts":[],"measurementInstructionTypes":[1,2],"TypeOfStructure":1,"IsRoofProduct":true,"SortOrder":44,"AllowsUserSubmittedPhotos":false},{"productID":46,"name":"Gutter - Residential","description":"Gutter","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":12.0000,"priceMax":12.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000},{"productID":7,"name":"3 Hour","description":"Three Hour Delivery","isTemporarilyUnavailable":false,"priceMin":40.0000,"priceMax":40.0000}],"addOnProducts":[],"measurementInstructionTypes":[2],"TypeOfStructure":1,"IsRoofProduct":true,"SortOrder":46,"AllowsUserSubmittedPhotos":false},{"productID":51,"name":"WallsLite","description":"WallsLite™","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":36.0000,"priceMax":36.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000}],"addOnProducts":[],"measurementInstructionTypes":[1,2,3,4,5],"TypeOfStructure":1,"IsRoofProduct":false,"SortOrder":51,"AllowsUserSubmittedPhotos":false},{"productID":57,"name":"Blueprint - Residential","description":"Premium","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":30.0000,"priceMax":75.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000}],"addOnProducts":[],"measurementInstructionTypes":[1,2,3,4,5],"TypeOfStructure":1,"IsRoofProduct":true,"SortOrder":57,"AllowsUserSubmittedPhotos":false},{"productID":60,"name":"SunSite Plus - Residential","description":"SunSite™ Plus","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":50.0000,"priceMax":95.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000},{"productID":4,"name":"Express","description":"Express Delivery","isTemporarilyUnavailable":false,"priceMin":30.0000,"priceMax":30.0000}],"addOnProducts":[],"measurementInstructionTypes":[1,2,3,4,5],"TypeOfStructure":1,"IsRoofProduct":true,"SortOrder":60,"AllowsUserSubmittedPhotos":false},{"productID":32,"name":"Premium - Commercial","description":"Premium","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":85.0000,"priceMax":85.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000},{"productID":4,"name":"Express","description":"Express Delivery","isTemporarilyUnavailable":false,"priceMin":30.0000,"priceMax":30.0000},{"productID":7,"name":"3 Hour","description":"Three Hour Delivery","isTemporarilyUnavailable":false,"priceMin":40.0000,"priceMax":40.0000}],"addOnProducts":[],"measurementInstructionTypes":[1,2,3,4,5],"TypeOfStructure":2,"IsRoofProduct":true,"SortOrder":3,"AllowsUserSubmittedPhotos":true},{"productID":12,"name":"SunSite - Commercial","description":"SunSite™","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":90.0000,"priceMax":90.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000},{"productID":4,"name":"Express","description":"Express Delivery","isTemporarilyUnavailable":false,"priceMin":30.0000,"priceMax":30.0000},{"productID":7,"name":"3 Hour","description":"Three Hour Delivery","isTemporarilyUnavailable":false,"priceMin":40.0000,"priceMax":40.0000}],"addOnProducts":[],"measurementInstructionTypes":[1,2,3,4,5],"TypeOfStructure":2,"IsRoofProduct":true,"SortOrder":6,"AllowsUserSubmittedPhotos":true},{"productID":47,"name":"Gutter - Commercial","description":"Gutter","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":20.0000,"priceMax":20.0000,"deliveryProducts":[{"productID":8,"name":"Regular","description":"Regular Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000},{"productID":7,"name":"3 Hour","description":"Three Hour Delivery","isTemporarilyUnavailable":false,"priceMin":40.0000,"priceMax":40.0000}],"addOnProducts":[],"measurementInstructionTypes":[2],"TypeOfStructure":2,"IsRoofProduct":true,"SortOrder":47,"AllowsUserSubmittedPhotos":false},{"productID":55,"name":"QuickSquares - Multi-Family","description":"QuickSquares™","productGroup":null,"isTemporarilyUnavailable":false,"priceMin":36.0000,"priceMax":36.0000,"deliveryProducts":[{"productID":45,"name":"Quick","description":"Quick Delivery","isTemporarilyUnavailable":false,"priceMin":0.0000,"priceMax":0.0000}],"addOnProducts":[],"measurementInstructionTypes":[2],"TypeOfStructure":3,"IsRoofProduct":true,"SortOrder":55,"AllowsUserSubmittedPhotos":false}]');
            res.setStatusCode(200);
            return res;
        }
        if(req.getEndpoint().contains('GrantUserOrderDelegation')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Message":"The request is invalid.","ModelState":{"grantUserOrderDelegationModel.UserName":["The UserName field is required.","The UserName field is not a valid e-mail address."],"grantUserOrderDelegationModel.Password":["The Password field is required."]}}');
            res.setStatusCode(200);
            return res;
        }
        if(req.getEndpoint().contains('PlaceOrder')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Message":"Object reference not set to an instance of an object."}');
            res.setStatusCode(200);
            return res;
        }
        if(req.getEndpoint().contains('get_access_token')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": 200,"requestMethod": "POST","token": "t3stToKen"}');
            res.setStatusCode(200);
            return res;

        }
        if(req.getEndpoint().contains('contractors')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": 200,"requestMethod": "POST","token": "t3stToKen", "contractor_id": "123456"}');
            res.setStatusCode(200);
            return res;

        }
        if(req.getEndpoint().contains('GetReport') | req.getEndpoint().contains('CloseReport')){

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Message":"The request is invalid."}');
            res.setStatusCode(200);
            return res;
        }else{

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"approved"}');
            res.setStatusCode(200);
            return res;

        }


    }


}