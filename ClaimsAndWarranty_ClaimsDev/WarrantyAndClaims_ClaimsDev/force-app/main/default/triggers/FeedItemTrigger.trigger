/**
 * @description FeedItem Trigger
 * @author Sinan Bunni
 * @date 2019-09-18.
 */
trigger FeedItemTrigger on FeedItem (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {

    if (System.Trigger.isAfter && System.Trigger.isInsert) {
        FeedItemService.bringDownCaseChatterFeedToLabSample(System.Trigger.new);
    }

} // end FeedItemTrigger trigger