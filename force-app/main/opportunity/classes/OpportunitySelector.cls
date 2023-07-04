/**
 * Retrieves information about {@link Opportunity} records.
 */
public inherited sharing class OpportunitySelector {
  private final Set<String> premiumProducts;

  public OpportunitySelector(Set<String> premiumProducts) {
    this.premiumProducts = premiumProducts;
  }

  /**
   * Returns {@link Opportunity} records with their child {@link OpportunityLineItem} records.
   */
  public List<Opportunity> getOpportunityWithLineItems(
    List<Id> opportunityIds
  ) {
    return [
      SELECT
        Id,
        AccountId,
        IsWon,
        IsClosed,
        (SELECT Id, Product2.Name FROM OpportunityLineItems)
      FROM Opportunity
      WHERE Id IN :opportunityIds
    ];
  }
  /**
   * Returns open {@link Opportunity} records with their child {@link OpportunityLineItem} records that have premium
   * products.
   */
  public List<Opportunity> getOpenOpportunitiesWithPremiumLineItems(
    List<Id> accountIds
  ) {
    return [
      SELECT
        Id,
        AccountId,
        (
          SELECT Id
          FROM OpportunityLineItems
          WHERE Product2.Name IN :premiumProducts
        )
      FROM Opportunity
      WHERE AccountId IN :accountIds AND IsClosed = FALSE
    ];
  }
}