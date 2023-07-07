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
        'Expected to get the SObjectType from the records in the trigger. Found {0} from Trigger.new {1} and Trigger.oldMap {2}',
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
        triggerHandler.onBeforeDelete(sobjects);
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

  @TestVisible
  private abstract class TriggerTest {
    @TestVisible
    private void run() {
      FakeTriggerHandler fakeTriggerHandler = new FakeTriggerHandler();
      FakeTriggerHandlerProvider fakeTriggerHandlerProvider = new FakeTriggerHandlerProvider(
        fakeTriggerHandler
      );
      TriggerRunner.triggerHandlerProvider = fakeTriggerHandlerProvider;

      try {
        insertSObject();
      } catch (DmlException e) {
        // empty catch block because we just want to cause the trigger to run
      }

      Assert.areEqual(1, fakeTriggerHandler.beforeInsertCallTimes);
    }

    @TestVisible
    private abstract void insertSObject();
  }

  @TestVisible
  private class FakeTriggerHandlerProvider extends TriggerHandlerProvider {
    private final TriggerHandler triggerHandler;

    @TestVisible
    private FakeTriggerHandlerProvider(TriggerHandler triggerHandler) {
      super(null);

      this.triggerHandler = triggerHandler;
    }

    public override TriggerHandler get(SObjectType sobjectType) {
      return triggerHandler;
    }
  }

  @TestVisible
  private class FakeTriggerHandler implements TriggerHandler {
    @TestVisible
    private Integer beforeInsertCallTimes = 0;
    @TestVisible
    private Integer beforeUpdateCallTimes = 0;
    @TestVisible
    private Integer beforeDeleteCallTimes = 0;
    @TestVisible
    private Integer afterInsertCallTimes = 0;
    @TestVisible
    private Integer afterUpdateCallTimes = 0;
    @TestVisible
    private Integer afterDeleteCallTimes = 0;
    @TestVisible
    private Integer afterUndeleteCallTimes = 0;

    public void onBeforeInsert(List<SObject> sobjects) {
      beforeInsertCallTimes++;
    }

    public void onBeforeUpdate(
      List<SObject> sobjects,
      Map<Id, SObject> oldSObjectsByIds
    ) {
      beforeUpdateCallTimes++;
    }

    public void onBeforeDelete(List<SObject> sobjects) {
      beforeDeleteCallTimes++;
    }

    public void onAfterInsert(List<SObject> sobjects) {
      afterInsertCallTimes++;
    }

    public void onAfterUpdate(
      List<SObject> sobjects,
      Map<Id, SObject> oldSObjectsByIds
    ) {
      afterUpdateCallTimes++;
    }

    public void onAfterDelete(List<SObject> oldSObjects) {
      afterDeleteCallTimes++;
    }

    public void onAfterUndelete(List<SObject> sobjects) {
      afterUndeleteCallTimes++;
    }
  }
}