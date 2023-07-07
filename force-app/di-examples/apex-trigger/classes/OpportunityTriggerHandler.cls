/**
 * Trigger handler that handles {@link Opportunity} DML operations.
 */
public inherited sharing class OpportunityTriggerHandler implements TriggerHandler {
  @TestVisible
  private static Selector selector = new Selector();

  private final AccountChecker accountChecker;
  private final OpportunityChecker opportunityChecker;
  private final PremiumOpportunityFactory premiumOpportunityFactory;
  private final PremiumOpportunityService premiumOpportunityService;

  public OpportunityTriggerHandler(
    AccountChecker accountChecker,
    OpportunityChecker opportunityChecker,
    PremiumOpportunityFactory premiumOpportunityFactory,
    PremiumOpportunityService nextOpportunityService
  ) {
    this.accountChecker = accountChecker;
    this.opportunityChecker = opportunityChecker;
    this.premiumOpportunityFactory = premiumOpportunityFactory;
    this.premiumOpportunityService = nextOpportunityService;
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
    List<Opportunity> opportunities = selector.getOpportunities(sobjects);

    List<PremiumOpportunity> premiumOpportunities = new List<PremiumOpportunity>();
    for (Opportunity opportunity : opportunities) {
      if (
        opportunityChecker.isClosedWon(opportunity) &&
        !accountChecker.isPremiumCustomer(opportunity.Account) &&
        !opportunityChecker.hasPremiumProduct(opportunity)
      ) {
        premiumOpportunities.add(
          premiumOpportunityFactory.createFor(opportunity.AccountId)
        );
      }
    }

    if (premiumOpportunities.size() > 0) {
      premiumOpportunityService.createPremiumOpportunities(
        premiumOpportunities
      );
    }
  }

  public void onAfterUpdate(
    List<SObject> sobjects,
    Map<Id, SObject> oldSObjectsByIds
  ) {
    List<Opportunity> opportunities = selector.getOpportunities(sobjects);

    List<PremiumOpportunity> premiumOpportunities = new List<PremiumOpportunity>();
    for (Opportunity opportunity : opportunities) {
      if (
        !opportunityChecker.isClosedWon(
          (Opportunity) oldSObjectsByIds.get(opportunity.Id)
        ) &&
        opportunityChecker.isClosedWon(opportunity) &&
        !accountChecker.isPremiumCustomer(opportunity.Account) &&
        !opportunityChecker.hasPremiumProduct(opportunity)
      ) {
        premiumOpportunities.add(
          premiumOpportunityFactory.createFor(opportunity.AccountId)
        );
      }
    }

    if (premiumOpportunities.size() > 0) {
      premiumOpportunityService.createPremiumOpportunities(
        premiumOpportunities
      );
    }
  }

  public void onAfterDelete(List<SObject> oldSObjects) {
  }

  public void onAfterUndelete(List<SObject> sobjects) {
    // The same logic exists for `after insert`, so just call that method
    onAfterInsert(sobjects);
  }

  private class Selector {
    private List<Opportunity> getOpportunities(List<SObject> sobjects) {
      return [
        SELECT Id
        FROM Opportunity
        WHERE Id IN :sobjects
      ];
    }
  }
}