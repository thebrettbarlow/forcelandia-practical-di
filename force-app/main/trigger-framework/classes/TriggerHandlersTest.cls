/**
 * Tests for {@link TriggerHandlers}.
 */
@IsTest(IsParallel=true)
private class TriggerHandlersTest {
  @IsTest
  private static void mapping_eachSObjectTypeMappedToTriggerHandler() {
    for (SObjectType sobjectType : TriggerHandlers.MAPPING.keySet()) {
      Assert.isInstanceOfType(
        TriggerHandlers.MAPPING.get(sobjectType),
        TriggerHandler.class
      );
    }
  }
}