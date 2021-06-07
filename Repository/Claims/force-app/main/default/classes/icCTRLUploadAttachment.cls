public class icCTRLUploadAttachment {
    
    public Blob attBody { get; set; }
    public String fileName { get; set; }
    public Integer fileSize { get; set; }
    public String contentType { get; set; }
    private Id parentRecordId;

    private icLogicAttachment.IClass logicAttachment = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
    
    public icCTRLUploadAttachment(){
        
        parentRecordId = ApexPages.currentPage().getParameters().get('id');
        
    }
    
    public PageReference uploadFile() {
        
        if( attBody != null ) {
            try { 
                logicAttachment.createDocumentInObject(parentRecordId, fileName, fileName, attBody);
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.CONFIRM, 'File uploaded successfully.') );
            } catch ( Exception e ) {
                ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.ERROR, 'File upload failed due to "' + e.getMessage() + '".') );
            }
            
            attBody = null;
            fileName = '';
        }
        else {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.ERROR, 'Please choose a file.') );
        }
        
        PageReference pg = Page.icPageUploadAttachment;
        pg.setRedirect( false );
        return pg;
    }
}