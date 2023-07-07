/**
 * Represents a Premium {@link Opportunity}.
 */
public inherited sharing class PremiumOpportunity {
  public final Id accountId;
  public final String stageName;
  public final String name;
  public final Date closeDate;

  public Opportunity toOpportunity() {
    return null;
  }

  public List<OpportunityLineItem> toOpportunityLineItems() {
    return null;
  }
}