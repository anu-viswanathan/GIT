/**
 * Created by Andrea Pissinis on 2018-09-10.
 */
@isTest
public with sharing class icTestDTO {

    public static testMethod void testDTOMapicsData(){
        icDTOMapicsData testDTO = new icDTOMapicsData();
        testDTO.dhaenb = 'dhaenb';
        testDTO.fechnb = 'fechnb';
        testDTO.slsnm = 'slsnm';
        testDTO.feabbj = 'feabbj';
        testDTO.bfhitx = 'bfhitx';
        testDTO.ikgrpnam = 'ikgrpnam';
        testDTO.iksupnam = 'iksupnam';
        testDTO.ddaitx = 'ddaitx';
        testDTO.umstad = 'umstad';
        testDTO.pid1Aw = 'pid1Aw';
        testDTO.pid2Aw = 'pid2Aw';
        testDTO.uuccad = 'uuccad';
        testDTO.rcode = 'rcode';
        testDTO.shpyear = 'shpyear';
        testDTO.shpmonth = 'shpmonth';
        testDTO.ddarqt = 'ddarqt';
        testDTO.dddpva = 'dddpva';
        testDTO.squares = 'squares';
        testDTO.curid = 'curid';
        testDTO.status = 'status';
    }

    public static testMethod void testDTOWhatsHappeningResult(){
        icDTOWhatsHappeningResult dtoWhatsHappeningResult = new icDTOWhatsHappeningResult();
        dtoWhatsHappeningResult.content = new List<icDTOWhatsHappening>();
        dtoWhatsHappeningResult.theme = 'theme';
    }

    public static testMethod void testDTOWhatsHappening(){

       icDTOWhatsHappening dtoWhatsHappening = new icDTOWhatsHappening();

        dtoWhatsHappening.imageId  = null;
        dtoWhatsHappening.title  = null;
        dtoWhatsHappening.description = null;
        dtoWhatsHappening.externalLink  = null;
        dtoWhatsHappening.communityLink  = null;
        dtoWhatsHappening.mobileLink  = null;
        dtoWhatsHappening.linkType  = null;
    }


    public static testMethod void testContactUsDTO(){

       icDTOContactUs c = new icDTOContactUs();

        c.repName  = null;
        c.repPhone  = null;
        c.repMobile = null;
        c.repEmail  = null;
        c.repInfo  = null;

        System.assertEquals(c.repName  , null);
        System.assertEquals(c.repPhone  , null);
        System.assertEquals(c.repMobile , null);
        System.assertEquals(c.repEmail  , null);
        System.assertEquals(c.repInfo  , null);

    }

    public static testMethod void testApplicantDTO(){

        icDTOApplicantDetails d = new icDTOApplicantDetails();

        d.applicantFirstName = null;
        d.applicantMiddleInitial = null;
        d.applicantLastName = null;
        d.applicantStreetAddress = null;
        d.applicantStreetNumber = null;
        d.applicantOtherAddress = null;
        d.applicantCity = null;
        d.applicantState = null;
        d.applicantZipCode = null;
        d.applicantZipCode4 = null;
        d.applicantPhoneNumber = null;
        d.applicantCellPhoneNumber = null;
        d.applicantEmailAddress = null;
        d.applicantSSN = null;
        d.applicantDateOfBirth = null;
        d.applicantGrossIncome = null;
        d.applicantNameOnId = null;
        d.applicantIDNumber = null;
        d.applicantTypeOfID = null;
        d.applicantStateOnID = null;
        d.applicantIDExpiryDate = null;
        d.applicantMarried = null;

        System.assertEquals(d.applicantFirstName , null);
        System.assertEquals(d.applicantMiddleInitial , null);
        System.assertEquals(d.applicantLastName , null);
        System.assertEquals(d.applicantStreetAddress , null);
        System.assertEquals(d.applicantStreetNumber , null);
        System.assertEquals(d.applicantOtherAddress , null);
        System.assertEquals(d.applicantCity , null);
        System.assertEquals(d.applicantState , null);
        System.assertEquals(d.applicantZipCode , null);
        System.assertEquals(d.applicantZipCode4 , null);
        System.assertEquals(d.applicantPhoneNumber , null);
        System.assertEquals(d.applicantCellPhoneNumber , null);
        System.assertEquals(d.applicantEmailAddress , null);
        System.assertEquals(d.applicantSSN , null);
        System.assertEquals(d.applicantDateOfBirth , null);
        System.assertEquals(d.applicantGrossIncome , null);
        System.assertEquals(d.applicantNameOnId , null);
        System.assertEquals(d.applicantIDNumber , null);
        System.assertEquals(d.applicantTypeOfID , null);
        System.assertEquals(d.applicantStateOnID , null);
        System.assertEquals(d.applicantIDExpiryDate , null);
        System.assertEquals(d.applicantMarried , null);

    }

    public static testMethod void testCOApplicantDTO(){

        icDTOcoApplicantDetails co = new icDTOcoApplicantDetails();

        co.coapplicantFirstName = null;
        co.coapplicantLastName = null;
        co.coApplicantMiddleIntial = null;
        co.coapplicantStreetAddress = null;
        co.coapplicantStreetNumber = null;
        co.coapplicantOtherAddress = null;
        co.coapplicantCity = null;
        co.coapplicantState = null;
        co.coapplicantZipCode = null;
        co.coapplicantZipCode4 = null;
        co.coapplicantPhoneNumber = null;
        co.coapplicantCellPhoneNumber = null;
        co.coapplicantEmailAddress = null;
        co.coapplicantSSN = null;
        co.coapplicantDateOfBirth = null;
        co.coapplicantGrossIncome = null;
        co.coapplicantNameOnId = null;
        co.coapplicantIDNumber = null;
        co.coapplicantTypeOfID = null;
        co.coapplicantStateOnID = null;
        co.coapplicantIDExpiryDate = null;
        co.coapplicantMarried = null;

        System.assertEquals(co.coapplicantFirstName , null);
        System.assertEquals(co.coapplicantLastName , null);
        System.assertEquals(co.coApplicantMiddleIntial , null);
        System.assertEquals(co.coapplicantStreetAddress , null);
        System.assertEquals(co.coapplicantStreetNumber , null);
        System.assertEquals(co.coapplicantOtherAddress , null);
        System.assertEquals(co.coapplicantCity , null);
        System.assertEquals(co.coapplicantState , null);
        System.assertEquals(co.coapplicantZipCode , null);
        System.assertEquals(co.coapplicantZipCode4 , null);
        System.assertEquals(co.coapplicantPhoneNumber , null);
        System.assertEquals(co.coapplicantCellPhoneNumber , null);
        System.assertEquals(co.coapplicantEmailAddress , null);
        System.assertEquals(co.coapplicantSSN , null);
        System.assertEquals(co.coapplicantDateOfBirth , null);
        System.assertEquals(co.coapplicantGrossIncome , null);
        System.assertEquals(co.coapplicantNameOnId , null);
        System.assertEquals(co.coapplicantIDNumber , null);
        System.assertEquals(co.coapplicantTypeOfID , null);
        System.assertEquals(co.coapplicantStateOnID , null);
        System.assertEquals(co.coapplicantIDExpiryDate , null);
        System.assertEquals(co.coapplicantMarried , null);

    }

    public static testmethod void testEagleViewOrderFormDTO(){

        icDTOEagleViewOrderForm f = new icDTOEagleViewOrderForm();
        f.streetAddress = null;
        f.city = null;
        f.state = null;
        f.postalCode = null;
        f.country = null;
        f.propertyType = null;
        f.product = null;
        f.delivery = null;
        f.measurementType = null;
        f.specialInstructions = null;
        f.changesInLast4Years = null;

        System.assertEquals(f.streetAddress , null);
        System.assertEquals(f.city , null);
        System.assertEquals(f.state , null);
        System.assertEquals(f.postalCode , null);
        System.assertEquals(f.country , null);
        System.assertEquals(f.propertyType , null);
        System.assertEquals(f.product , null);
        System.assertEquals(f.delivery , null);
        System.assertEquals(f.measurementType , null);
        System.assertEquals(f.specialInstructions , null);
        System.assertEquals(f.changesInLast4Years , null);

    }

    public static testMethod void testEagleViewOrderReportDTO(){

        icDTOEagleViewOrderReport r = new icDTOEagleViewOrderReport();
        r.ReportAddresses = new List<icDTOEagleViewReportAddress>{};
        r.PrimaryProductId = null;
        r.DeliveryProductId = null;
        r.MeasurementInstructionType = null;
        r.ChangesInLast4Years = null;

        System.assertEquals(r.ReportAddresses , new List<icDTOEagleViewReportAddress>{});
        System.assertEquals(r.PrimaryProductId , null);
        System.assertEquals(r.DeliveryProductId , null);
        System.assertEquals(r.MeasurementInstructionType , null);
        System.assertEquals(r.ChangesInLast4Years , null);

    }

    public static testMethod void testEagleViewPlaceOrderRequestDTO(){

        icDTOEagleViewPlaceOrderRequest pr = new icDTOEagleViewPlaceOrderRequest();

        pr.OrderReports = new List<icDTOEagleViewOrderReport>{};

        System.assertEquals(pr.OrderReports , new List<icDTOEagleViewOrderReport>{});

    }

    public static testMethod void testEagleViewPlaceOrderResponseDTO(){

        icDTOEagleViewPlaceOrderResponse rsp = new icDTOEagleViewPlaceOrderResponse();

        rsp.OrderId = null;
        rsp.ReportIds = new List<Integer>{};
        rsp.message = null;

        System.assertEquals( rsp.OrderId , null);
        System.assertEquals( rsp.ReportIds , new List<Integer>{});
        System.assertEquals( rsp.message , null);
    }

    public static testMethod void testEagleViewProductDTO(){

        icDTOEagleViewProduct p = new icDTOEagleViewProduct();

        p.addOnProducts = new List<icDTOEagleViewProduct>{};
        p.AllowsUserSubmittedPhotos = null;
        p.deliveryProducts = new List<icDTOEagleViewProduct>{};
        p.description = null;
        p.IsRoofProduct = null;
        p.isTemporarilyUnavailable = null;
        p.measurementInstructionTypes = new List<Integer>{};
        p.name = null;
        p.priceMax = null;
        p.priceMin = null;
        p.productGroup = null;
        p.productID = null;
        p.SortOrder = null;
        p.TypeOfStructure = null;

        System.assertEquals(p.addOnProducts , new List<icDTOEagleViewProduct>{});
        System.assertEquals(p.AllowsUserSubmittedPhotos , null);
        System.assertEquals(p.deliveryProducts , new List<icDTOEagleViewProduct>{});
        System.assertEquals(p.description , null);
        System.assertEquals(p.IsRoofProduct , null);
        System.assertEquals(p.isTemporarilyUnavailable , null);
        System.assertEquals(p.measurementInstructionTypes , new List<Integer>{});
        System.assertEquals(p.name , null);
        System.assertEquals(p.priceMax , null);
        System.assertEquals(p.priceMin , null);
        System.assertEquals(p.productGroup , null);
        System.assertEquals(p.productID , null);
        System.assertEquals(p.SortOrder , null);
        System.assertEquals(p.TypeOfStructure , null);

    }

    public static testMethod void testEagleViewReportAddressDTO(){

        icDTOEagleViewReportAddress a = new icDTOEagleViewReportAddress();

        a.Address = null;
        a.City = null;
        a.Country = null;
        a.State = null;
        a.Zip = null;

        System.assertEquals(a.Address , null);
        System.assertEquals(a.City , null);
        System.assertEquals(a.Country , null);
        System.assertEquals(a.State , null);
        System.assertEquals(a.Zip , null);

    }

    public static testMethod void testEagleViewTokenDTO(){

        icDTOEagleViewToken t = new icDTOEagleViewToken();

        t.access_token = null;
        t.expires_in = null;
        t.refresh_token = null;
        t.token_type = null;

        System.assertEquals(t.access_token , null);
        System.assertEquals(t.expires_in , null);
        System.assertEquals(t.refresh_token , null);
        System.assertEquals(t.token_type , null);

    }

    public static testMethod void testGenericResultDTO(){

        icDTOGenericResult r = new icDTOGenericResult();
        r.isSuccess = null;
        r.message = null;

        System.assertEquals(r.isSuccess , null);
        System.assertEquals(r.message , null);

    }

    public static testMethod void testGreenSkyApplicationDTO(){

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.applicationId = null;
        a.token = null;
        a.error = null;
        a.GreenSkyApplicationSFId = null;
        a.opportunityId = null;
        a.accountId = null;
        a.requestedAmount = null;

        System.assertEquals(a.applicationId , null);
        System.assertEquals(a.token , null);
        System.assertEquals(a.error , null);
        System.assertEquals(a.GreenSkyApplicationSFId , null);
        System.assertEquals(a.opportunityId , null);
        System.assertEquals(a.accountId , null);
        System.assertEquals(a.requestedAmount , null);
    }

    public static testMethod void testGrenSkyApplicationStateDTO(){

        icDTOGreenSkyApplicationState s = new icDTOGreenSkyApplicationState();

        s.applicantAddressEntryRequired = null;
        s.applicationInfoReviewRequired = null;
        s.applicationState = null;
        s.applicationStatus = null;
        s.coApplicantAddressEntryRequired = null;
        s.error = null;
        s.nextState = null;

        System.assertEquals( s.applicantAddressEntryRequired , null);
        System.assertEquals( s.applicationInfoReviewRequired , null);
        System.assertEquals( s.applicationState , null);
        System.assertEquals( s.applicationStatus , null);
        System.assertEquals( s.coApplicantAddressEntryRequired , null);
        System.assertEquals( s.error , null);
        System.assertEquals( s.nextState , null);

    }

    public static testMethod void testGreenSkyCreateDTO(){

        icDTOGreenSkyCreate c = new icDTOGreenSkyCreate();

        c.error = null;
        c.Status = null;

        System.assertEquals(c.error , null);
        System.assertEquals(c.Status , null);

    }

    public static testMethod void testGreenSkyDecisionDTO(){

        icDTOGreenSkyDecision d = new icDTOGreenSkyDecision();

        d.applicantFullName = null;
        d.error = null;
        d.requestedLoanAmount = null;
        d.status = null;

        System.assertEquals(d.applicantFullName , null);
        System.assertEquals(d.error , null);
        System.assertEquals(d.requestedLoanAmount , null);
        System.assertEquals(d.status , null);

    }

    public static testMethod void testGreenSkyEmailDTO(){

        icDTOGreenSkyEmail e = new icDTOGreenSkyEmail();

        e.error = null;
        e.status = null;

        System.assertEquals(e.error , null);
        System.assertEquals(e.status , null);

    }

    public static testMethod void testGreenSkyErrorDTO(){

        icDTOGreenSkyError e = new icDTOGreenSkyError();

        e.code = null;
        e.message = null;

        System.assertEquals(e.code , null);
        System.assertEquals(e.message , null);

    }

    public static testMethod void testGreenSkyListsDTO(){

        icDTOGreenSkyLists l = new icDTOGreenSkyLists();

        l.states = null;
        l.typeOfId = null;
        l.youAre = null;

        System.assertEquals(l.states , null);
        System.assertEquals(l.typeOfId , null);
        System.assertEquals(l.youAre , null);

        l.setlists(new List<String>{}, new List<String>{}, new List<String>{});

    }

    public static testMethod void testGreenSkyLoanAgreementDTO(){

        icDTOGreenSkyLoanAgreement a = new icDTOGreenSkyLoanAgreement();

        a.amountFinanced = null;
        a.applicantEmail = null;
        a.applicantFullName = null;
        a.apr = null;
        a.creditProduct = null;
        a.error = null;
        a.lender = null;
        a.monthlyPayment = null;
        a.promotionDetails = null;
        a.term = null;

        System.assertEquals(a.amountFinanced , null);
        System.assertEquals(a.applicantEmail , null);
        System.assertEquals(a.applicantFullName , null);
        System.assertEquals(a.apr , null);
        System.assertEquals(a.creditProduct , null);
        System.assertEquals(a.error , null);
        System.assertEquals(a.lender , null);
        System.assertEquals(a.monthlyPayment , null);
        System.assertEquals(a.promotionDetails , null);
        System.assertEquals(a.term , null);

    }

    public static testMethod void testGreenSkyLoanOfferDTO(){

        icDTOGreenSkyLoanOffer lo = new icDTOGreenSkyLoanOffer();

        lo.apr = null;
        lo.creditProduct = null;
        lo.id = null;
        lo.isDeferred = null;
        lo.loanAmount = null;
        lo.monthlyPayment = null;
        lo.planNumber = null;
        lo.promotionDetails = null;
        lo.promotionPeriod = null;
        lo.secondLook = null;
        lo.term = null;

        System.assertEquals(lo.apr , null);
        System.assertEquals(lo.creditProduct , null);
        System.assertEquals(lo.id , null);
        System.assertEquals(lo.isDeferred , null);
        System.assertEquals(lo.loanAmount , null);
        System.assertEquals(lo.monthlyPayment , null);
        System.assertEquals(lo.planNumber , null);
        System.assertEquals(lo.promotionDetails , null);
        System.assertEquals(lo.promotionPeriod , null);
        System.assertEquals(lo.secondLook , null);
        System.assertEquals(lo.term , null);

    }

    public static testMethod void testGreenSkyMerchantValidationDTO(){

        icDTOGreenSkyMerchantValidation m = new icDTOGreenSkyMerchantValidation();
        m.affected  = null ;
        m.applicationFlow  = null ;
        m.creditProduct  = null ;
        m.error  = null ;
        m.isValid  = null ;
        m.merchantName  = null ;
        m.program  = null ;
        m.token  = null ;

        System.assertEquals(m.affected  , null );
        System.assertEquals(m.applicationFlow  , null );
        System.assertEquals(m.creditProduct  , null );
        System.assertEquals(m.error  , null );
        System.assertEquals(m.isValid  , null );
        System.assertEquals(m.merchantName  , null );
        System.assertEquals(m.program  , null );
        System.assertEquals(m.token  , null );

    }

    public static testMethod void testGreenSkyMerchantValidationRequestDTO(){

        icDTOGreenSkyMerchantValidationRequest r = new icDTOGreenSkyMerchantValidationRequest();

        r.channel = null;
        r.dealer = null;
        r.plan = null;
        r.program = null;
        r.role = null;

        System.assertEquals(r.channel , null);
        System.assertEquals(r.dealer , null);
        System.assertEquals(r.plan , null);
        System.assertEquals(r.program , null);
        System.assertEquals(r.role , null);

    }

    public static testMethod void testGreenSkyOfferDTO(){

        icDTOGreenSkyOffer o = new icDTOGreenSkyOffer();

        o.applicantFullName = null ;
        o.applicationStatus = null ;
        o.error = null ;
        o.offers = null ;
        o.paymentTermOfferMessage = null ;
        o.planNumber = null ;
        o.submissionDate = null ;

        System.assertEquals(o.applicantFullName , null );
        System.assertEquals(o.applicationStatus , null );
        System.assertEquals(o.error , null );
        System.assertEquals(o.offers , null );
        System.assertEquals(o.paymentTermOfferMessage, null);
        System.assertEquals(o.planNumber , null );
        System.assertEquals(o.submissionDate, null);

    }

    public static testMethod void testHAAppointmentDTO(){

        icDTOHAAppointment a = new icDTOHAAppointment();
        a.appointmentOid = null;
        a.end_HA = null;
        a.external_id = null;
        a.start = null;
        a.status = null;
        a.type_HA = null;

        System.assertEquals(a.appointmentOid , null);
        System.assertEquals(a.end_HA , null);
        System.assertEquals(a.external_id , null);
        System.assertEquals(a.start , null);
        System.assertEquals(a.status , null);
        System.assertEquals(a.type_HA , null);

    }

    public static testMethod void testHALeadDTO(){

        icDTOHALead l = new icDTOHALead();

        l.name = null;
        l.address = null;
        l.appointment = null;
        l.city = null;
        l.comments = null;
        l.crmKey = null;
        l.email = null;
        l.firstName = null;
        l.interview = null;
        l.lastName = null;
        l.leadDescription = null;
        l.leadOid = null;
        l.matchType = null;
        l.name = null;
        l.phoneExt = null;
        l.postalCode = null;
        l.primaryPhone = null;
        l.secondaryPhone = null;
        l.secondaryPhoneExt = null;
        l.spCompanyName = null;
        l.spEntityId = null;
        l.spPartnerId = null;
        l.srOid = null;
        l.stateProvince = null;
        l.taskName = null;
        l.taskOid = null;

        System.assertEquals(l.address , null);
        System.assertEquals(l.appointment , null);
        System.assertEquals(l.city , null);
        System.assertEquals(l.comments , null);
        System.assertEquals(l.crmKey , null);
        System.assertEquals(l.email , null);
        System.assertEquals(l.firstName , null);
        System.assertEquals(l.interview , null);
        System.assertEquals(l.lastName , null);
        System.assertEquals(l.leadDescription , null);
        System.assertEquals(l.leadOid , null);
        System.assertEquals(l.matchType , null);
        System.assertEquals(l.name , null);
        System.assertEquals(l.phoneExt , null);
        System.assertEquals(l.postalCode , null);
        System.assertEquals(l.primaryPhone , null);
        System.assertEquals(l.secondaryPhone , null);
        System.assertEquals(l.secondaryPhoneExt , null);
        System.assertEquals(l.spCompanyName , null);
        System.assertEquals(l.spEntityId , null);
        System.assertEquals(l.spPartnerId , null);
        System.assertEquals(l.srOid , null);
        System.assertEquals(l.stateProvince , null);
        System.assertEquals(l.taskName , null);
        System.assertEquals(l.taskOid , null);

    }

    public static testMethod void testHaQuestionDTO(){

        icDTOHAQuestion q = new icDTOHAQuestion();

        q.answer = null;
        q.question = null;

        System.assertEquals( q.answer , null);
        System.assertEquals( q.question , null);

    }

    public static testMethod void testLoanDetailsDTO(){

        icDTOLoanDetails ld = new icDTOLoanDetails();

        ld.coApplicantIndicator = null;
        ld.contractLanguage = null;
        ld.requestedLoanAmount = null;
        ld.referenceNumber = null;
        ld.program = null;
        ld.product = null;
        ld.role = null;
        ld.channel = null;
        ld.promotionCode = null;
        ld.referral = null;
        ld.youAre = null;

        System.assertEquals(ld.coApplicantIndicator , null);
        System.assertEquals(ld.contractLanguage , null);
        System.assertEquals(ld.requestedLoanAmount , null);
        System.assertEquals(ld.referenceNumber , null);
        System.assertEquals(ld.program , null);
        System.assertEquals(ld.product , null);
        System.assertEquals(ld.role , null);
        System.assertEquals(ld.channel , null);
        System.assertEquals(ld.promotionCode , null);
        System.assertEquals(ld.referral , null);
        System.assertEquals(ld.youAre , null);
    }

    public static testMethod void testLoanFormDTO(){

        icDTOLoanForm f = new icDTOLoanForm();

        f.coApplicantIndicator = null;
        f.contractLanguage = null;
        f.requestedLoanAmount = null;
        f.referenceNumber = null;
        f.program = null;
        f.product = null;
        f.role = null;
        f.channel = null;
        f.promotionCode = null;
        f.referral = null;
        //f.merchantNumber = null;
        f.youAre = null;
        f.applicantFirstName = null;
        f.applicantMiddleInitial = null;
        f.applicantLastName = null;
        f.applicantStreetAddress = null;
        f.applicantStreetNumber = null;
        f.applicantOtherAddress = null;
        f.applicantCity = null;
        f.applicantState = null;
        f.applicantZipCode = null;
        f.applicantZipCode4 = null;
        f.applicantPhoneNumber = null;
        f.applicantCellPhoneNumber = null;
        f.applicantEmailAddress = null;
        f.applicantSSN = null;
        f.applicantDateOfBirth = null;
        f.applicantGrossIncome = null;
        f.applicantNameOnId = null;
        f.applicantIDNumber = null;
        f.applicantTypeOfID = null;
        f.applicantStateOnID = null;
        f.applicantIDExpiryDate = null;
        f.applicantMarried = null;
        f.coApplicantFirstName = null;
        f.coApplicantMiddleIntial = null;
        f.coApplicantLastName = null;
        f.coApplicantStreetAddress = null;
        f.coApplicantStreetNumber = null;
        f.coApplicantOtherAddress = null;
        f.coApplicantCity = null;
        f.coApplicantState = null;
        f.coApplicantZipCode = null;
        f.coApplicantZipCode4 = null;
        f.coApplicantPhoneNumber = null;
        f.coApplicantCellPhoneNumber = null;
        f.coApplicantEmailAddress = null;
        f.coApplicantSSN = null;
        f.coApplicantDateOfBirth = null;
        f.coApplicantGrossIncome = null;
        f.coApplicantNameOnId = null;
        f.coApplicantIDNumber = null;
        f.coApplicantTypeOfID = null;
        f.coApplicantStateOnID = null;
        f.coApplicantIDExpiryDate = null;
        f.coApplicantMarried = null;
        //f.shippingAddress1 = null;
        //f.shippingAddress2 = null;
        //f.shippingCity = null;
        //f.shippingState = null;
        //f.shippingZip = null;
        //f.fingerPrint = null;

        System.assertEquals(f.coApplicantIndicator , null);
        System.assertEquals(f.contractLanguage , null);
        System.assertEquals(f.requestedLoanAmount , null);
        System.assertEquals(f.referenceNumber , null);
        System.assertEquals(f.program , null);
        System.assertEquals(f.product , null);
        System.assertEquals(f.role , null);
        System.assertEquals(f.channel , null);
        System.assertEquals(f.promotionCode , null);
        System.assertEquals(f.referral , null);
        //System.assertEquals(f.merchantNumber, null);
        System.assertEquals(f.youAre , null);
        System.assertEquals(f.applicantFirstName , null);
        System.assertEquals(f.applicantMiddleInitial , null);
        System.assertEquals(f.applicantLastName , null);
        System.assertEquals(f.applicantStreetAddress , null);
        System.assertEquals(f.applicantStreetNumber , null);
        System.assertEquals(f.applicantOtherAddress , null);
        System.assertEquals(f.applicantCity , null);
        System.assertEquals(f.applicantState , null);
        System.assertEquals(f.applicantZipCode , null);
        System.assertEquals(f.applicantZipCode4 , null);
        System.assertEquals(f.applicantPhoneNumber , null);
        System.assertEquals(f.applicantCellPhoneNumber , null);
        System.assertEquals(f.applicantEmailAddress , null);
        System.assertEquals(f.applicantSSN , null);
        System.assertEquals(f.applicantDateOfBirth , null);
        System.assertEquals(f.applicantGrossIncome , null);
        System.assertEquals(f.applicantNameOnId , null);
        System.assertEquals(f.applicantIDNumber , null);
        System.assertEquals(f.applicantTypeOfID , null);
        System.assertEquals(f.applicantStateOnID , null);
        System.assertEquals(f.applicantIDExpiryDate , null);
        System.assertEquals(f.applicantMarried , null);
        System.assertEquals(f.coApplicantFirstName , null);
        System.assertEquals(f.coApplicantMiddleIntial , null);
        System.assertEquals(f.coApplicantLastName , null);
        System.assertEquals(f.coApplicantStreetAddress , null);
        System.assertEquals(f.coApplicantStreetNumber , null);
        System.assertEquals(f.coApplicantOtherAddress , null);
        System.assertEquals(f.coApplicantCity , null);
        System.assertEquals(f.coApplicantState , null);
        System.assertEquals(f.coApplicantZipCode , null);
        System.assertEquals(f.coApplicantZipCode4 , null);
        System.assertEquals(f.coApplicantPhoneNumber , null);
        System.assertEquals(f.coApplicantCellPhoneNumber , null);
        System.assertEquals(f.coApplicantEmailAddress , null);
        System.assertEquals(f.coApplicantSSN , null);
        System.assertEquals(f.coApplicantDateOfBirth , null);
        System.assertEquals(f.coApplicantGrossIncome , null);
        System.assertEquals(f.coApplicantNameOnId , null);
        System.assertEquals(f.coApplicantIDNumber , null);
        System.assertEquals(f.coApplicantTypeOfID , null);
        System.assertEquals(f.coApplicantStateOnID , null);
        System.assertEquals(f.coApplicantIDExpiryDate , null);
        System.assertEquals(f.coApplicantMarried , null);
        //System.assertEquals(f.shippingAddress1, null);
        //System.assertEquals(f.shippingAddress2, null);
        //System.assertEquals(f.shippingCity, null);
        //System.assertEquals(f.shippingState, null);
        //System.assertEquals(f.shippingZip, null);
        //System.assertEquals(f.fingerPrint, null);


    }

    public static testMethod void testPaypalPaymentResponse(){

        icDTOPaypalPaymentResponse dto = new icDTOPaypalPaymentResponse();
        dto.id = '';
        dto.intent = '';
        dto.state = '';
        dto.cart = '';
        dto.create_time = '';
        dto.payer = new icDTOPaypalPayer();
        dto.transactions = new List<icDTOPaypalTransactionItem>();

        dto.payer.payment_method = '';
        dto.payer.status = '';
        dto.payer.payer_info = new icDTOPaypalPayerInfo();

        dto.payer.payer_info.email = '';
        dto.payer.payer_info.phone = '';
        dto.payer.payer_info.first_name = '';
        dto.payer.payer_info.last_name = '';
        dto.payer.payer_info.payer_id = '';
        dto.payer.payer_info.country_code = '';
        dto.payer.payer_info.shipping_address = new icDTOPaypalShippingAddress();

        dto.payer.payer_info.shipping_address.recipient_name = '';
        dto.payer.payer_info.shipping_address.line1 = '';
        dto.payer.payer_info.shipping_address.city = '';
        dto.payer.payer_info.shipping_address.state = '';
        dto.payer.payer_info.shipping_address.postal_code = '';
        dto.payer.payer_info.shipping_address.country_code = '';

        icDTOPaypalTransactionItem dtoTransItem = new icDTOPaypalTransactionItem();
        dtoTransItem.amount = new icDTOPaypalAmount();
        dtoTransItem.related_resources = new List<icDTOPaypalRelatedResourcesItems>();

        dtoTransItem.amount.total = '';
        dtoTransitem.amount.paymentcurrency = '';
        dtoTransItem.amount.details = new icDTOPaypalAmoutDetail();

        dtoTransItem.amount.details.subtotal = '';

        icDTOPaypalRelatedResourcesItems dtoResItem = new icDTOPaypalRelatedResourcesItems();
        dtoResItem.sale = new icDTOPaypalSale();

        dtoResItem.sale.id = '';
        dtoResItem.sale.saleState = '';
        dtoResItem.sale.payment_mode = '';
        dtoResItem.sale.protection_eligibility = '';
        dtoResItem.sale.parent_payment = '';
        dtoResItem.sale.create_time = '';
        dtoResItem.sale.update_time = '';
        dtoResItem.sale.amount = new icDTOPaypalAmount();
        dtoResItem.sale.amount.total = '';
        dtoResItem.sale.amount.paymentcurrency = '';
        dtoResItem.sale.amount.details = new icDTOPaypalAmoutDetail();
        dtoResItem.sale.amount.details.subtotal = '';

        dtoTransItem.related_resources.add(dtoResItem);
        dto.transactions.add(dtoTransItem);

        icDTOPaypalRelatedResources dtoRelRes = new icDTOPaypalRelatedResources();
        dtoRelRes.relatedResourcesItems = new List<icDTOPaypalRelatedResourcesItems>();
        dtoRelRes.relatedResourcesItems.add(dtoResItem);

        icDTOPaypalTokenResponse dtoToken = new icDTOPaypalTokenResponse();
        dtoToken.scope = '';
        dtoToken.nonce = '';
        dtoToken.access_token = '';
        dtoToken.token_type = '';
        dtoToken.app_id = '';
        dtoToken.expires_in = 1;

        icDTOPaypalTransactions dtoTrans = new icDTOPaypalTransactions();
        dtoTrans.transactionItem = new List<icDTOPaypalTransactionItem>();
        dtoTrans.transactionItem.add(dtoTransItem);

    }


    public static testMethod void testProzoneRemoteAuthDTO(){

        icDTOProzoneRemoteAuth p = new icDTOProzoneRemoteAuth();
        p.accountId = null;
        p.sessionId = null;
        p.userLanguage = null;

        System.assertEquals(p.accountId , null);
        System.assertEquals(p.sessionId , null);
        System.assertEquals(p.userLanguage , null);
    }

    public static testMethod void testQuickShotInfoDTO(){

        icDTOQuickShotInfo q = new icDTOQuickShotInfo();

        q.newLeads = null;
        q.currentOpportunities = null;
        q.squaresYTD = null;
        q.pro4Rewards = null;
        q.coopRewards = null;

        System.assertEquals(q.newLeads , null);
        System.assertEquals(q.currentOpportunities , null);
        System.assertEquals(q.squaresYTD , null);
        System.assertEquals(q.pro4Rewards , null);
        System.assertEquals(q.coopRewards , null);

    }

    public static testMethod void testSelectOptionDTO(){

        icDTOSelectOption o = new icDTOSelectOption();
        o.value = null;
        o.label = null;
        o.isDisabled = null;

        System.assertEquals(o.value ,null);
        System.assertEquals(o.label ,null);
        System.assertEquals(o.isDisabled ,null);

    }

    public static testMethod void test_icDtoTierMovementConfig() {
        icDtoTierMovementConfig testDtoTierMovementConfig = new icDtoTierMovementConfig();
        testDtoTierMovementConfig.sfId = 'sfId';
        testDtoTierMovementConfig.runProcess = true;
        testDtoTierMovementConfig.processMode = 'processMode';
        testDtoTierMovementConfig.rebateYear = 'rebateYear';
        testDtoTierMovementConfig.adminEmail = 'adminEmail';
        testDtoTierMovementConfig.startDate = Date.today();
        testDtoTierMovementConfig.endDate = Date.today();
    }
}