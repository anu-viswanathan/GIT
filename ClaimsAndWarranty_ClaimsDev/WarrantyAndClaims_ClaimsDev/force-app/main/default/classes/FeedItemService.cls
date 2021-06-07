/**
 * @description FeedItem Trigger service and controller
 * @author Sinan Bunni
 * @date 2019-09-18.
 */
public class FeedItemService {

    /**
     * @description Copy down the Case Chatter to the Lab Sample object
     * @param newFeedItems New Feed Item records
     */
    public static void bringDownCaseChatterFeedToLabSample(List<FeedItem> newFeedItems) {

        Map<Id, String> feedContentByCaseIds = new Map<Id, String>();

        // Iterate through the feeds that are posted on Cases (i.e. Id starts with 500)
        for (FeedItem feedItem : newFeedItems) {
            String feedItemParentId = feedItem.ParentId;
            if (feedItemParentId.startsWith('500') && feedItem.Body != NULL) {
                if (!feedContentByCaseIds.containsKey(feedItem.ParentId)) {
                    feedContentByCaseIds.put(feedItem.ParentId, feedItem.Body);
                } 
            }
        }

        if (feedContentByCaseIds.isEmpty()) {
            return;
        }

        List<FeedItem> toInsert = new List<FeedItem>();
        for (Lab_Sample__c labSample : [SELECT Id, Case__c FROM Lab_Sample__c WHERE Case__c IN :feedContentByCaseIds.keySet()]) {
            toInsert.add(
                    new FeedItem(
                            ParentId = labSample.Id,
                            Body = feedContentByCaseIds.get(labSample.Case__c),
                            IsRichText = true
                    )
            );
        }

        if (!toInsert.isEmpty()) {
            Database.upsert(toInsert, false);
        }

    } // end bringDownCaseChatterFeedToLabSample method

    /**
     * @description When a Lab Sample is created and the parent Case has Chatter Feeds associated
     *  Bring down all the Chatter Feed from the Case to Lab Sample records
     *
     * @param newLabSamples list of the new versions of the Lab Sample records.
     */
  /*  public static void bringDownCaseChatterFeedToLabSample(final List<Lab_Sample__c> newLabSamples) {

        // Retrieve the parent Cases to the new Lab Samples
        Set<Id> caseIds = new Set<Id>();
        for (Lab_Sample__c labSample : newLabSamples) {
            caseIds.add(labSample.Case__c);
        }

        if (caseIds.isEmpty()) {
            return;
        }

        // Generate a Map where key is the Case Id and value is a list of feed comments associated with the Case
        Map<Id, List<String>> feedContentByCaseIds = new Map<Id, List<String>>();
        for (FeedItem feedItem : [SELECT Id, Body, ParentId, IsRichText FROM FeedItem WHERE ParentId IN :caseIds]) {
            String feedItemParentId = feedItem.ParentId;
            if (feedItemParentId.startsWith('500') && feedItem.Body != NULL) {
                if (!feedContentByCaseIds.containsKey(feedItemParentId)) {
                    feedContentByCaseIds.put(feedItem.ParentId, new List<String>{
                            feedItem.Body
                    });
                } else {
                    feedContentByCaseIds.get(feedItem.ParentId).add(feedItem.Body);
                }
            }
        }

        if (feedContentByCaseIds.isEmpty()) {
            return;
        }

        // Copy Down all the Case FeedItems to the new Lab Sample records
        List<FeedItem> toInsert = new List<FeedItem>();
        for (Lab_Sample__c labSample : newLabSamples) {
            if (feedContentByCaseIds.containsKey(labSample.Case__c)) {
                for (String feedBody : feedContentByCaseIds.get(labSample.Case__c)) {
                    toInsert.add(
                            new FeedItem(
                                    ParentId = labSample.Id,
                                    Body = feedBody,
                                    IsRichText = true
                            )
                    );
                }
            }
        }

        if (!toInsert.isEmpty()) {
            Database.upsert(toInsert, false);
        }

    } // end bringDownCaseChatterFeedToLabSample method*/

} // end FeedItemService class