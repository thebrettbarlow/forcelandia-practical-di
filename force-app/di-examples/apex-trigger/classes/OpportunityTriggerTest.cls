/**
 * Test that runs the {@link Opportunity} {@link Trigger}.
 */
@IsTest(IsParallel=true)
private class OpportunityTriggerTest extends TriggerRunner.TriggerTest {
  @IsTest
  private static void run() {
    new OpportunityTriggerTest().run();
  }

  private override void insertSObject() {
    insert new Opportunity();
  }
}