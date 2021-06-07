public class SendCertificateEventTriggerHandler extends TriggerHandlerFramework  {
    
    protected override void afterInsert() {
        List<SendCertificate__e> sendCertificateEvents = (List<SendCertificate__e>) Trigger.new;

        for (SendCertificate__e sendCertificate : sendCertificateEvents) {
            IKOCertificateCompletionEmail.sendCertificateByEmail(sendCertificate.AchievementId__c, sendCertificate.AchievementAssignmentId__c);
        }
    }
}