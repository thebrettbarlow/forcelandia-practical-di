/**
 * Apex Trigger that handles {@link Opportunity} DML operations.
 */
trigger OpportunityTrigger on Opportunity(
  before insert,
  before update,
  before delete,
  after insert,
  after update,
  after delete,
  after undelete
) {
  TriggerRunner.run(Trigger.new, Trigger.oldMap, Trigger.operationType);
}