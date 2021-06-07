// 2019-12-17 Skot
// Modified as per this support article https://success.salesforce.com/issues_view?id=a1p300000008XHfAAM
// Chatter answers is a deprecated feature
 
global class ChatterAnswersAuthProviderRegistration implements Auth.RegistrationHandler{

global User createUser(Id portalId, Auth.UserData data){
	return null;
}
global void updateUser(Id userId, Id portalId, Auth.UserData data){
}

}