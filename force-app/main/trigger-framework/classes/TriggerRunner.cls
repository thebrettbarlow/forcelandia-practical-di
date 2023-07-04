/**
 * Runs a {@link Trigger} by delegating to a {@link TriggerHandler}.
 */
public inherited sharing class TriggerRunner {
  @TestVisible
  private static TriggerHandlerProvider triggerHandlerProvider = new TriggerHandlerProvider(
    TriggerHandlers.MAPPING
  );

  /**
   * Processes the records in the {@link Trigger} according to the {@link TriggerOperation}.
   */
  public static void run(
    List<SObject> sobjects,
    Map<Id, SObject> oldSObjectsByIds,
    TriggerOperation triggerOperation
  ) {
    SObjectType sobjectType;
    if (sobjects.size() > 0) {
      sobjectType = sobjects[0].getSObjectType();
    } else if (oldSObjectsByIds.size() > 0) {
      sobjectType = oldSObjectsByIds.values()[0].getSObjectType();
    } else {
      return;
    }

    TriggerHandler triggerHandler = triggerHandlerProvider.get(sobjectType);
    switch on triggerOperation {
      when BEFORE_INSERT {
        triggerHandler.onBeforeInsert(sobjects);
      }
      when BEFORE_UPDATE {
        triggerHandler.onBeforeUpdate(sobjects, oldSObjectsByIds);
      }
      when BEFORE_DELETE {
        triggerHandler.onAfterDelete(sobjects);
      }
      when AFTER_INSERT {
        triggerHandler.onAfterInsert(sobjects);
      }
      when AFTER_UPDATE {
        triggerHandler.onAfterUpdate(sobjects, oldSObjectsByIds);
      }
      when AFTER_DELETE {
        triggerHandler.onAfterDelete(sobjects);
      }
      when AFTER_UNDELETE {
        triggerHandler.onAfterUndelete(sobjects);
      }
    }
  }
}