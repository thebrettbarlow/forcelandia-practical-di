/**
 * Performs operations related to Premium {@link Opportunity} records.
 */
public inherited sharing class PremiumOpportunityService {
  /**
   * Creates a premium {@link Opportunity} record for each {@link Account}.
   */
  public void createPremiumOpportunities(
    List<PremiumOpportunity> premiumOpportunities
  ) {
    throw new UnexpectedException('not implemented');
  }

  @TestVisible
  private class Selector {
    @TestVisible
    private Set<Id> getAccountIdsWithOpenPremiumOpportunities(
      Set<Id> accountId
    ) {
      throw new UnexpectedException('not implemented');
    }
  }

  @TestVisible
  private class Writer {
    @TestVisible
    private void insertOpportunities(List<Opportunity> opportunities) {
      throw new UnexpectedException('not implemented');
    }

    @TestVisible
    private void insertOpportunityLineItems(
      List<OpportunityLineItem> opportunityLineItems
    ) {
      throw new UnexpectedException('not implemented');
    }
  }
}