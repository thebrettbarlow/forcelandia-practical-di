/**
 * Trigger handler that handles {@link Opportunity} DML operations.
 */
public inherited sharing class OpportunityTriggerHandler implements TriggerHandler {
  private final PremiumOpportunityService nextOpportunityService;
  private final OpportunitySelector opportunitySelector;

  public OpportunityTriggerHandler(
    PremiumOpportunityService nextOpportunityService,
    OpportunitySelector opportunitySelector
  ) {
    this.nextOpportunityService = nextOpportunityService;
    this.opportunitySelector = opportunitySelector;
  }

  public void onBeforeInsert(List<SObject> sobjects) {
  }

  public void onBeforeUpdate(
    List<SObject> sobjects,
    Map<Id, SObject> oldSObjectsByIds
  ) {
  }

  public void onBeforeDelete(List<SObject> sobjects) {
  }

  public void onAfterInsert(List<SObject> sobjects) {
    List<Opportunity> opportunities = opportunitySelector.getOpportunityWithLineItems(
      SObjectUtil.collectIds(sobjects, Opportunity.Id)
    );

    nextOpportunityService.run(opportunities);
  }

  public void onAfterUpdate(
    List<SObject> sobjects,
    Map<Id, SObject> oldSObjectsByIds
  ) {
    List<Opportunity> opportunities = opportunitySelector.getOpportunityWithLineItems(
      SObjectUtil.collectIds(sobjects, Opportunity.Id)
    );
    Map<Id, Opportunity> oldOpportunitiesByIds = (Map<Id, Opportunity>) oldSObjectsByIds;

    nextOpportunityService.run(opportunities, oldOpportunitiesByIds);
  }

  public void onAfterDelete(List<SObject> oldSObjects) {
  }

  public void onAfterUndelete(List<SObject> sobjects) {
    List<Opportunity> opportunities = opportunitySelector.getOpportunityWithLineItems(
      SObjectUtil.collectIds(sobjects, Opportunity.Id)
    );

    nextOpportunityService.run(opportunities);
  }
}