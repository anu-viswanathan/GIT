/**
 * Enum type used for various events in triggers. It is used by AbstractTriggerHandler to indicate what mode
 * (DML operation type) is the current execution context. This allows to avoid usage of trigger variables (e.g.
 * Trigger.isBefore, Trigger.isInsert etc.) when implementing code that we want to be reused in situations where
 * the trigger context is not available.
 *
 * @author Michał Zagańczyk (michal.zaganczyk@4cconsulting.com)
 */
public enum TriggerEventType {

    /**
     * Indicates that the current execution context is "before insert"
     */
    BEFORE_INSERT,

    /**
     * Indicates that the current execution context is "before update"
     */
    BEFORE_UPDATE,

    /**
     * Indicates that the current execution context is "before delete"
     */
    BEFORE_DELETE,

    /**
     * Indicates that the current execution context is "after insert"
     */
    AFTER_INSERT,

    /**
     * Indicates that the current execution context is "after update"
     */
    AFTER_UPDATE,

    /**
     * Indicates that the current execution context is "after delete"
     */
    AFTER_DELETE,

    /**
     * Indicates that the current execution context is "after undelete"
     */
    AFTER_UNDELETE
}