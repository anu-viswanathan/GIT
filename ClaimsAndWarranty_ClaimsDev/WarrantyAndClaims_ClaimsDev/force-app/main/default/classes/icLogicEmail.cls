public class icLogicEmail implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		EmailTemplate getEmailTemplateByDevName(String templateDevName);
		OrgWideEmailAddress getOrgWideEmailByName(String orgWideEmailName);
		void sendPlainTextEmail(String subject, String body, List<String> recipients, List<String> ccRecipients, List<String> bccRecipients, List<String> entities, List<Messaging.EmailFileAttachment> attachments);
		void sendTemplateEmail(EmailTemplate template, String recipientId, String relatedObjectId, List<String> entities, List<Messaging.EmailFileAttachment> attachments);
        void sendTemplateEmailActivity(EmailTemplate template, String recipientId, String relatedObjectId, String fromAddress ,List<String> entities, List<Messaging.EmailFileAttachment> attachments, boolean withActivity);
		Messaging.SingleEmailMessage RenderEmailTemplate(EmailTemplate template, String userId, String whatId, List<String> entities, List<Messaging.EmailFileAttachment> attachments);
	}

	public class Impl implements IClass {

		icRepoEmail.IClass repository = (icRepoEmail.IClass) icObjectFactory.GetSingletonInstance('icRepoEmail');

		public EmailTemplate getEmailTemplateByDevName(String templateDevName) {
			return repository.getEmailTemplateByDevName(templateDevName);
		}

		public OrgWideEmailAddress getOrgWideEmailByName(String orgWideEmailName) {
			return repository.getOrgWideEmailByName(orgWideEmailName);
		}

		public void sendPlainTextEmail(String subject, String body, List<String> recipients, List<String> ccRecipients, List<String> bccRecipients, List<String> entities, List<Messaging.EmailFileAttachment> attachments) {
			Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
			emailOut.setSubject(subject);
			emailOut.setPlainTextBody(body);
			emailOut.setToAddresses(recipients);
			if(ccRecipients.size() > 0) {
				emailOut.setCcAddresses(ccRecipients);
			}
			if(bccRecipients.size() > 0) {
				emailOut.setBccAddresses(bccRecipients);
			}
			if(entities.size() > 0) {
				emailOut.setEntityAttachments(entities);
			}
			if(attachments.size() > 0 ) {
				emailOut.setFileAttachments(attachments);
			}
			if(!test.isRunningTest()) {
				Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
						emailOut
				});
			}
		}

		public void sendTemplateEmail(EmailTemplate template, String recipientId, String relatedObjectId, List<String> entities, List<Messaging.EmailFileAttachment> attachments) {
			Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
			emailOut.setTemplateID(template.Id);
            emailOut.setTargetObjectId(recipientId);
			emailOut.setWhatId(relatedObjectId);
			emailOut.setSaveAsActivity(false);
			if(entities.size() > 0) {
				emailOut.setEntityAttachments(entities);
			}
			if(attachments.size() > 0 ) {
				emailOut.setFileAttachments(attachments);
			}

			if(!Test.isRunningTest()) {
				Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
						emailOut
				});
			}
		}
        
        public void sendTemplateEmailActivity(EmailTemplate template, String recipientId, String relatedObjectId, String fromAddress, List<String> entities, List<Messaging.EmailFileAttachment> attachments, boolean withActivity) {
			Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
			emailOut.setTemplateID(template.Id);
            emailOut.setReplyTo(fromAddress);
			emailOut.setTargetObjectId(recipientId);
			emailOut.setWhatId(relatedObjectId);
			emailOut.setSaveAsActivity(withActivity);
			if(entities.size() > 0) {
				emailOut.setEntityAttachments(entities);
			}
			if(attachments.size() > 0 ) {
				emailOut.setFileAttachments(attachments);
			}

			if(!Test.isRunningTest()) {
				Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
						emailOut
				});
			}
		}

		//IKO-259 subtask IKO-298
		public Messaging.SingleEmailMessage RenderEmailTemplate(EmailTemplate template, String userId, String whatId, List<String> entities, List<Messaging.EmailFileAttachment> attachments){
			Messaging.SingleEmailMessage emailOut;
			if(!Test.isRunningTest()) {
				emailOut = Messaging.renderStoredEmailTemplate(template.Id, userId, whatId);
			} else {
				emailOut = new Messaging.SingleEmailMessage();
			}

			String emailSubject = emailOut.getSubject();
			String emailTextBody = emailOut.getPlainTextBody();

			emailOut.setTargetObjectId(userId);
			emailOut.setSubject(emailSubject);
			emailOut.setPlainTextBody(emailTextBody);
			emailOut.setSaveAsActivity(false);
			if(entities.size() > 0){
				emailOut.setEntityAttachments(entities);
			}
			if(attachments.size() > 0 ){
				emailOut.setFileAttachments(attachments);
			}
			return emailOut;
		}
	}
}