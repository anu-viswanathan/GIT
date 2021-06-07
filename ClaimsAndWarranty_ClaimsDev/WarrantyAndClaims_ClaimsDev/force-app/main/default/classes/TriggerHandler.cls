/**
 * Abstract class used as a basis to enforce the uniform and consistent approach to handle trigger events of any SObject.
 *
 * All implementations in the descendants for individual SObject types should extend this class and provide their own
 * actual implementation by overriding the virtual methods to provide their own specific functionality and behavior.
 *
 * @author Michał Zagańczyk (michal.zaganczyk@4cconsulting.com)
 *
 * Logs:
 * 02/09/2019 Maarten Devos, added extra methods to handle List<sObject> instead of Map<Id, sObject>
 */
public abstract class TriggerHandler {

    /**
     * Stores the trigger event type that the handler is executing in.
     */
    public TriggerEventType eventType { get; private set; }

    /**
     * Redirects the execution to appropriate method depending on the current values of Trigger state variables.
     *
     * It has been implemented to simplify the access to the trigger record collection variables (eg. Trigger.new
     * or Trigger.oldMap etc.). It resolves which record collection variable is available at current execution
     * context / state, for example that there is no such thing like "before undelete" event or that only the
     * Trigger.newMap is available for the "after undelete" execution context, and so on.
     *
     * This method implementation is 100% functional and in most situations the behavior will not (and should not)
     * need to be modified. But in case if the different behavior is expected here, the method has been implemented
     * as virtual to allow for overriding in the descendants.
     */
    public virtual void run() {
        if (Trigger.isExecuting) {
            if (Trigger.isBefore) {
                if (Trigger.isInsert) {
                    this.eventType = TriggerEventType.BEFORE_INSERT;
                    this.onBeforeInsert((List<SObject>) Trigger.new);
                } else if (Trigger.isUpdate) {
                    this.eventType = TriggerEventType.BEFORE_UPDATE;
                    this.onBeforeUpdate((Map<Id, SObject>) Trigger.newMap, (Map<Id, SObject>) Trigger.oldMap);
                } else if (Trigger.isDelete) {
                    this.eventType = TriggerEventType.BEFORE_DELETE;
                    this.onBeforeDelete((Map<Id, SObject>) Trigger.oldMap);
                }
            } else if (Trigger.isAfter) {
                if (Trigger.isInsert) {
                    this.eventType = TriggerEventType.AFTER_INSERT;
                    this.onAfterInsert((Map<Id, SObject>) Trigger.newMap);
                } else if (Trigger.isUpdate) {
                    this.eventType = TriggerEventType.AFTER_UPDATE;
                    this.onAfterUpdate((Map<Id, SObject>) Trigger.newMap, (Map<Id, SObject>) Trigger.oldMap);
                } else if (Trigger.isDelete) {
                    this.eventType = TriggerEventType.AFTER_DELETE;
                    this.onAfterDelete((Map<Id, SObject>) Trigger.oldMap);
                } else if (Trigger.isUndelete) {
                    this.eventType = TriggerEventType.AFTER_UNDELETE;
                    this.onAfterUndelete((Map<Id, SObject>) Trigger.newMap);
                }
            }
        }
    }

    /**
     * Executed when "before insert" event occurs.
     *
     * In the "before insert" event the records being inserted don't have the Id values yet, so we cannot use newMap
     * from Trigger variable (which is more preferable approach in most cases as it gives the fast access to records
     * by their Ids when searching for individual record from the collection is needed).
     *
     * Implement the code to handle this event in the descendant classes. To get specific SObject type records,
     * use typecasting in the actual implementation.
     *
     * It has not been made abstract, instead of that we use empty body implementation. This is made this way
     * to avoid having to implement this method in descenants when it is not used.
     *
     * @param newList List<SObject> of records being inserted.
     */
    protected virtual void onBeforeInsert(List<SObject> newList) {
    }

    /**
     * Executed when "after insert" event occurs.
     *
     * In the "after insert" event the records being inserted already have the Id values, so now we can use newMap from
     * Trigger variables (which is more preferable approach in most cases as it gives the fast access to records by their
     * Ids when searching for individual record from the collection is needed). If the list is needed instead of a map -
     * we can get the list by calling newMap.values() method.
     *
     * Implement the code to handle this event in the descendant classes. To get specific SObject type records,
     * use typecasting in the actual implementation.
     *
     * It has not been made abstract, instead of that we use empty body implementation. This is made this way
     * to avoid having to implement this method in descenants when it is not used.
     *
     * @param newMap Map<Id, SObject> new version of the records being inserted.
     */
    protected virtual void onAfterInsert(Map<Id, SObject> newMap) {
    }

    /**
     * Executed when "before update" event occurs.
     * This is also the step number 3 in SObject merge operation (merge winning SObjects are updated).
     *
     * We can use oldMap and newMap from Trigger variables which is preferable approach in most cases as it gives
     * the fast access to records by their Ids  when searching for individual record from the collection is needed.
     * If the list is needed instead of a map - we can get the list by calling newMap.values() method.
     *
     * Implement the code to handle this event in the descendant classes. To get specific SObject type records,
     * use typecasting in the actual implementation.
     *
     * It has not been made abstract, instead of that we use empty body implementation. This is made this way
     * to avoid having to implement this method in descenants when it is not used.
     *
     * @param newMap Map<Id, SObject> new version of the records being updated.
     *
     * @param oldMap Map<Id, SObject> old version of the records being updated.
     */
    protected virtual void onBeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    /**
     * Executed when "after update" event occurs.
     * This is also the step number 4 in SObject merge operation (merge winning SObjects are updated).
     *
     * We can use oldMap and newMap from Trigger variables which is preferable approach in most cases as it gives
     * the fast access to records by their Ids  when searching for individual record from the collection is needed.
     * If the list is needed instead of a map - we can get the list by calling newMap.values() method.
     *
     * Implement the code to handle this event in the descendant classes. To get specific SObject type records,
     * use typecasting in the actual implementation.
     *
     * It has not been made abstract, instead of that we use empty body implementation. This is made this way
     * to avoid having to implement this method in descenants when it is not used.
     *
     * @param newMap Map<Id, SObject> new version of the records being updated.
     *
     * @param oldMap Map<Id, SObject> old version of the records being updated.
     */
    protected virtual void onAfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    /**
     * Executed when "before delete" event occurs.
     * This is also the step number 1 in SObject merge operation (merge losing SObjects are deleted).
     *
     * We can use oldMap from Trigger variables which is preferable approach in most cases as it gives the fast
     * access to records by their Ids  when searching for individual record from the collection is needed. If the
     * list is needed instead of a map - we can get the list by calling newMap.values() method.
     *
     * Implement the code to handle this event in the descendant classes. To get specific SObject type records,
     * use typecasting in the actual implementation.
     *
     * It has not been made abstract, instead of that we use empty body implementation. This is made this way
     * to avoid having to implement this method in descenants when it is not used.
     *
     * @param oldMap Map<Id, SObject> old version of the records being deleted.
     */
    protected virtual void onBeforeDelete(Map<Id, SObject> oldMap) {
    }

    /**
     * Executed when "after delete" event occurs.
     * This is also the step number 2 in SObject merge operation (merge losing SObjects are deleted).
     *
     * We can use oldMap from Trigger variables which is preferable approach in most cases as it gives the fast
     * access to records by their Ids  when searching for individual record from the collection is needed. If the
     * list is needed instead of a map - we can get the list by calling newMap.values() method.
     *
     * Implement the code to handle this event in the descendant classes. To get specific SObject type records,
     * use typecasting in the actual implementation.
     *
     * It has not been made abstract, instead of that we use empty body implementation. This is made this way
     * to avoid having to implement this method in descenants when it is not used.
     *
     * @param oldMap Map<Id, SObject> old version of the records being deleted.
     */
    protected virtual void onAfterDelete(Map<Id, SObject> oldMap) {
    }

    /**
     * Executed when "after undelete" event occurs.
     *
     * We can use newMap from Trigger variables which is preferable approach in most cases as it gives the fast
     * access to records by their Ids  when searching for individual record from the collection is needed. If the
     * list is needed instead of a map - we can get the list by calling newMap.values() method.
     *
     * Implement the code to handle this event in the descendant classes. To get specific SObject type records,
     * use typecasting in the actual implementation.
     *
     * It has not been made abstract, instead of that we use empty body implementation. This is made this way
     * to avoid having to implement this method in descenants when it is not used.
     *
     * @param newMap Map<Id, SObject> map of the records being undeleted.
     */
    protected virtual void onAfterUndelete(Map<Id, SObject> newMap) {
    }
}