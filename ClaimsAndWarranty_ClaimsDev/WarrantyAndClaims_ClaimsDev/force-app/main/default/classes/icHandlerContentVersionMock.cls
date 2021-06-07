@isTest
public with sharing class icHandlerContentVersionMock  implements icHandlerContentVersion.IClass {

  public void onAfterInsert(List<ContentVersion> contentVersions) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onAfterInsert');
		params.put('contentVersions', contentVersions);
    }

    /**
     * ClaimsV2-931
     * By Anil Mannem (Incloud) on 27-07-2020
     */
    public void onBeforeUpdate(List<ContentVersion> contentVersions) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeUpdate');
		params.put('contentVersions', contentVersions);
    }
}