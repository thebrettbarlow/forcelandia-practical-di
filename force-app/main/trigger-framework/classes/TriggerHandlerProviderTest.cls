/**
 * Tests for {@link TriggerHandlerProvider}.
 */
@IsTest(IsParallel=true)
private class TriggerHandlerProviderTest {
  @IsTest
  private static void get_sobjectTypeInMap_returnsTriggerHandler() {
    SObjectType sobjectType = Lead.SObjectType;
    Map<SObjectType, TriggerHandler> triggerHandlers = new Map<SObjectType, TriggerHandler>{
      sobjectType => new TriggerRunner.FakeTriggerHandler()
    };
    TriggerHandlerProvider triggerHandlerProvider = new TriggerHandlerProvider(
      triggerHandlers
    );

    TriggerHandler triggerHandler = triggerHandlerProvider.get(sobjectType);

    Assert.isNotNull(triggerHandler);
    Assert.isInstanceOfType(
      triggerHandler,
      TriggerRunner.FakeTriggerHandler.class
    );
  }

  @IsTest
  private static void get_sobjectTypeNotInMap_throws() {
    SObjectType sobjectType = Lead.SObjectType;
    Map<SObjectType, TriggerHandler> triggerHandlers = new Map<SObjectType, TriggerHandler>();
    TriggerHandlerProvider triggerHandlerProvider = new TriggerHandlerProvider(
      triggerHandlers
    );
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected Lead to be mapped to a TriggerHandler. Found null'
    );

    try {
      triggerHandlerProvider.get(sobjectType);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }
}