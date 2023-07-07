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
    SObjectType sobjectType = getSObjectType(sobjects, oldSObjectsByIds);
    Preconditions.checkArgument(
      sobjectType != null,
      String.format(
        'Expected to get the SObjectType from the records in the trigger. Found {0} from Trigger.new: {1} and Trigger.oldMap: {2}',
        new List<Object>{ sobjectType, sobjects, oldSObjectsByIds }
      )
    );

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

  private static SObjectType getSObjectType(
    List<SObject> sobjects,
    Map<Id, SObject> oldSObjectsByIds
  ) {
    if (sobjects.size() > 0) {
      return sobjects[0].getSObjectType();
    } else if (oldSObjectsByIds.size() > 0) {
      return oldSObjectsByIds.values()[0].getSObjectType();
    }

    return null;
  }
}