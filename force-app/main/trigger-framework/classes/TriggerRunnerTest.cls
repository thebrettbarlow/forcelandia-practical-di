/**
 * Tests for {@link TriggerRunner}.
 */
@IsTest(IsParallel=true)
private class TriggerRunnerTest {
  @IsTest
  private static void run_allTriggerOperations_eachCalledOnce() {
    List<Lead> leads = new List<Lead>{
      new Lead(Id = SObjectUtil.generateFakeId(Lead.SObjectType))
    };
    Map<Id, Lead> oldLeadsByIds = new Map<Id, Lead>(leads);
    TriggerRunner.FakeTriggerHandler fakeTriggerHandler = new TriggerRunner.FakeTriggerHandler();
    TriggerRunner.FakeTriggerHandlerProvider fakeTriggerHandlerProvider = new TriggerRunner.FakeTriggerHandlerProvider(
      fakeTriggerHandler
    );
    TriggerRunner.triggerHandlerProvider = fakeTriggerHandlerProvider;

    TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.BEFORE_INSERT);
    TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.BEFORE_UPDATE);
    TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.BEFORE_DELETE);
    TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.AFTER_INSERT);
    TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.AFTER_UPDATE);
    TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.AFTER_DELETE);
    TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.AFTER_UNDELETE);

    Assert.areEqual(1, fakeTriggerHandler.beforeInsertCallTimes);
    Assert.areEqual(1, fakeTriggerHandler.beforeUpdateCallTimes);
    Assert.areEqual(1, fakeTriggerHandler.beforeDeleteCallTimes);
    Assert.areEqual(1, fakeTriggerHandler.afterInsertCallTimes);
    Assert.areEqual(1, fakeTriggerHandler.afterUpdateCallTimes);
    Assert.areEqual(1, fakeTriggerHandler.afterDeleteCallTimes);
    Assert.areEqual(1, fakeTriggerHandler.afterUndeleteCallTimes);
  }

  @IsTest
  private static void run_emptyTriggerOldMap_doesNotThrow() {
    List<Lead> leads = new List<Lead>{ new Lead() };
    Map<Id, Lead> oldLeadsByIds = new Map<Id, Lead>();
    TriggerRunner.FakeTriggerHandler fakeTriggerHandler = new TriggerRunner.FakeTriggerHandler();
    TriggerRunner.FakeTriggerHandlerProvider fakeTriggerHandlerProvider = new TriggerRunner.FakeTriggerHandlerProvider(
      fakeTriggerHandler
    );
    TriggerRunner.triggerHandlerProvider = fakeTriggerHandlerProvider;
    AssertThrows.Throwing throwing = AssertThrows.doesNotThrow();

    try {
      TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.BEFORE_INSERT);
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
  }

  @IsTest
  private static void run_emptyTriggerNew_doesNotThrow() {
    List<Lead> leads = new List<Lead>();
    Lead lead = new Lead(Id = SObjectUtil.generateFakeId(Lead.SObjectType));
    Map<Id, Lead> oldLeadsByIds = new Map<Id, Lead>{ lead.Id => lead };
    TriggerRunner.FakeTriggerHandler fakeTriggerHandler = new TriggerRunner.FakeTriggerHandler();
    TriggerRunner.FakeTriggerHandlerProvider fakeTriggerHandlerProvider = new TriggerRunner.FakeTriggerHandlerProvider(
      fakeTriggerHandler
    );
    TriggerRunner.triggerHandlerProvider = fakeTriggerHandlerProvider;
    AssertThrows.Throwing throwing = AssertThrows.doesNotThrow();

    try {
      TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.BEFORE_INSERT);
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
  }

  @IsTest
  private static void run_emptyTriggerNewAndTriggerOldMap_throws() {
    List<Lead> leads = new List<Lead>();
    Map<Id, Lead> oldLeadsByIds = new Map<Id, Lead>();
    TriggerRunner.FakeTriggerHandler fakeTriggerHandler = new TriggerRunner.FakeTriggerHandler();
    TriggerRunner.FakeTriggerHandlerProvider fakeTriggerHandlerProvider = new TriggerRunner.FakeTriggerHandlerProvider(
      fakeTriggerHandler
    );
    TriggerRunner.triggerHandlerProvider = fakeTriggerHandlerProvider;
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected to get the SObjectType from the records in the trigger. Found null from Trigger.new () and Trigger.oldMap {}'
    );

    try {
      TriggerRunner.run(leads, oldLeadsByIds, TriggerOperation.BEFORE_INSERT);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }
}