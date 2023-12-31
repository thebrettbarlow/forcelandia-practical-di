/**
 * Performs operations related to Premium {@link Opportunity} records.
 */
public inherited sharing virtual class PremiumOpportunityService {
  @TestVisible
  private static Selector selector = new Selector();
  @TestVisible
  private static Writer writer = new Writer();

  private final OpportunityChecker opportunityChecker;

  public PremiumOpportunityService(OpportunityChecker opportunityChecker) {
    this.opportunityChecker = opportunityChecker;
  }

  /**
   * Creates a premium {@link Opportunity} record for each {@link Account}.
   */
  public virtual void createPremiumOpportunities(
    List<PremiumOpportunity> premiumOpportunities
  ) {
    Set<Id> accountIds = new Set<Id>();
    for (PremiumOpportunity premiumOpportunity : premiumOpportunities) {
      if (String.isNotBlank(premiumOpportunity.accountId)) {
        accountIds.add(premiumOpportunity.accountId);
      }
    }

    if (accountIds.isEmpty()) {
      return;
    }

    List<Opportunity> openOpportunities = selector.getOpenOpportunities(
      accountIds
    );
    Set<Id> accountIdsWithOpenPremiumOpportunities = new Set<Id>();
    for (Opportunity opportunity : openOpportunities) {
      if (
        opportunityChecker.hasPremiumProduct(opportunity.OpportunityLineItems)
      ) {
        accountIdsWithOpenPremiumOpportunities.add(opportunity.AccountId);
      }
    }

    List<Opportunity> opportunities = new List<Opportunity>();
    List<List<OpportunityLineItem>> opportunityLineItems = new List<List<OpportunityLineItem>>();
    for (PremiumOpportunity premiumOpportunity : premiumOpportunities) {
      if (
        !accountIdsWithOpenPremiumOpportunities.contains(
          premiumOpportunity.accountId
        )
      ) {
        opportunities.add(premiumOpportunity.toOpportunity());
        opportunityLineItems.add(premiumOpportunity.toOpportunityLineItems());
      }
    }

    if (opportunities.size() > 0) {
      Preconditions.checkArgument(
        opportunities.size() == opportunityLineItems.size(),
        String.format(
          'Expected each Opportunity to have their own OpportunityLineItems to create. Did not find the same number of Opportunities and Lists of OpportunityLine Items. Found Opportunities: {0}, OpportunityLineItem Lists: {1}',
          new List<Object>{ opportunities.size(), opportunityLineItems.size() }
        )
      );

      writer.insertOpportunities(opportunities);
      for (Integer i = 0; i < opportunities.size(); i++) {
        for (
          OpportunityLineItem opportunityLineItem : opportunityLineItems[i]
        ) {
          opportunityLineItem.OpportunityId = opportunities[i].Id;
        }
      }

      List<OpportunityLineItem> flattenedOpportunityLineItems = new List<OpportunityLineItem>();
      for (
        List<OpportunityLineItem> opportunityLineItemList : opportunityLineItems
      ) {
        flattenedOpportunityLineItems.addAll(opportunityLineItemList);
      }
      writer.insertOpportunityLineItems(flattenedOpportunityLineItems);
    }
  }

  /**
   * Retrieves records for {@link PremiumOpportunityService}.
   */
  @TestVisible
  private virtual class Selector {
    /**
     * Returns open {@link Opportunity} records for the list of {@link Account} Ids.
     */
    @TestVisible
    private virtual List<Opportunity> getOpenOpportunities(Set<Id> accountIds) {
      return [
        SELECT AccountId, (SELECT Id, Product2.Name FROM OpportunityLineItems)
        FROM Opportunity
        WHERE AccountId IN :accountIds AND IsClosed = FALSE
      ];
    }
  }

  /**
   * Performs DML operations on records for the {@link PremiumOpportunityService}.
   */
  @TestVisible
  private virtual class Writer {
    /**
     * Inserts {@link Opportunity} records.
     */
    @TestVisible
    private virtual void insertOpportunities(List<Opportunity> opportunities) {
      insert opportunities;
    }

    /**
     * Inserts {@link OpportunityLineItem} records.
     */
    @TestVisible
    private virtual void insertOpportunityLineItems(
      List<OpportunityLineItem> opportunityLineItems
    ) {
      insert opportunityLineItems;
    }
  }
}