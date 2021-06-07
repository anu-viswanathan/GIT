trigger CaseCommentTrigger on CaseComment  (before insert, before update, before delete,
		after insert, after update, after delete, after undelete) {

	if(System.Trigger.isBefore && System.Trigger.IsInsert) {
		CaseCommentService.blockCreate(System.Trigger.new);
	}

	if(System.Trigger.isBefore && System.Trigger.IsUpdate) {
		CaseCommentService.blockEditCaseComments(System.Trigger.new);
		CaseCommentService.blockUpdateDelete(System.Trigger.new);
	}

	if(System.Trigger.isBefore && System.Trigger.IsDelete) {
		CaseCommentService.blockDeletionCaseComments(System.Trigger.old);
		CaseCommentService.blockUpdateDelete(System.Trigger.old);
	}
}