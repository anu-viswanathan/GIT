trigger SendCertificateEventTrigger on SendCertificate__e (after insert) {
    new SendCertificateEventTriggerHandler().run();
}