/**
 * DML operations that are handled in an Apex Trigger.
 */
public interface TriggerHandler {
  /**
   * Handles the {@link TriggerOperation.BEFORE_INSERT} DML operation.
   */
  void onBeforeInsert(List<SObject> sobjects);

  /**
   * Handles the {@link TriggerOperation.BEFORE_UPDATE} DML operation.
   */
  void onBeforeUpdate(
    List<SObject> sobjects,
    Map<Id, SObject> oldSObjectsByIds
  );

  /**
   * Handles the {@link TriggerOperation.BEFORE_DELETE} DML operation.
   */
  void onBeforeDelete(List<SObject> sobjects);

  /**
   * Handles the {@link TriggerOperation.AFTER_INSERT} DML operation.
   */
  void onAfterInsert(List<SObject> sobjects);

  /**
   * Handles the {@link TriggerOperation.AFTER_UPDATE} DML operation.
   */
  void onAfterUpdate(List<SObject> sobjects, Map<Id, SObject> oldSObjectsByIds);

  /**
   * Handles the {@link TriggerOperation.AFTER_DELETE} DML operation.
   */
  void onAfterDelete(List<SObject> oldSObjects);

  /**
   * Handles the {@link TriggerOperation.AFTER_UNDELETE} DML operation.
   */
  void onAfterUndelete(List<SObject> sobjects);
}