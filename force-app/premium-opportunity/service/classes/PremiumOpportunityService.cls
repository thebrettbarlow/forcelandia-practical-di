/**
 * Creates {@code premium-opportunity} records.
 */
public inherited sharing class PremiumOpportunityService {
  private final OpportunityChecker opportunityChecker;
  private final OpportunityFactory opportunityFactory;
  private final OpportunitySelector opportunitySelector;
  private final OpportunityWriter opportunityWriter;

  public PremiumOpportunityService(
    OpportunityChecker opportunityChecker,
    OpportunityFactory opportunityFactory,
    OpportunitySelector opportunitySelector,
    OpportunityWriter opportunityWriter
  ) {
    this.opportunityChecker = opportunityChecker;
    this.opportunityFactory = opportunityFactory;
    this.opportunitySelector = opportunitySelector;
    this.opportunityWriter = opportunityWriter;
  }

  public void run(List<Opportunity> opportunities) {
    List<Opportunity> opportunitiesToProcess = new List<Opportunity>();
    for (Opportunity opportunity : opportunities) {
      if (opportunityChecker.needsNextOpportunity(opportunity)) {
        opportunitiesToProcess.add(opportunity);
      }
    }

    processOpportunities(opportunitiesToProcess);
  }

  public void run(
    List<Opportunity> opportunities,
    Map<Id, Opportunity> oldOpportunitiesByIds
  ) {
    List<Opportunity> opportunitiesToProcess = new List<Opportunity>();
    for (Opportunity opportunity : opportunities) {
      if (
        opportunityChecker.needsNextOpportunity(
          opportunity,
          oldOpportunitiesByIds.get(opportunity.Id)
        )
      ) {
        opportunitiesToProcess.add(opportunity);
      }
    }

    processOpportunities(opportunitiesToProcess);
  }

  private void processOpportunities(List<Opportunity> opportunities) {
    List<Id> accountIds = SObjectUtil.collectIds(
      opportunities,
      Opportunity.AccountId
    );
    List<Opportunity> existingNextOpportunities = opportunitySelector.getOpenOpportunitiesWithPremiumLineItems(
      accountIds
    );

    Map<Id, Boolean> hasExistingNextOpportunityByAccountId = new Map<Id, Boolean>();
    for (Opportunity opportunity : existingNextOpportunities) {
      if (
        opportunity.OpportunityLineItems != null &&
        opportunity.OpportunityLineItems.size() > 0
      ) {
        hasExistingNextOpportunityByAccountId.put(opportunity.AccountId, true);
      }
    }

    List<Opportunity> opportunitiesWithoutNextOpportunities = new List<Opportunity>();
    for (Opportunity opportunity : opportunities) {
      if (
        !hasExistingNextOpportunityByAccountId.containsKey(
          opportunity.AccountId
        )
      ) {
        opportunitiesWithoutNextOpportunities.add(opportunity);
      }
    }

    if (opportunitiesWithoutNextOpportunities.size() > 0) {
      opportunityWriter.databaseInsert(
        opportunityFactory.createPremiumOpportunities(
          opportunitiesWithoutNextOpportunities
        )
      );
    }
  }
}