/**
 * Returns information about the state of an {@link Opportunity} record.
 */
public inherited sharing class OpportunityChecker {
  private final Set<String> starterProducts;

  public OpportunityChecker(Set<String> starterProducts) {
    this.starterProducts = starterProducts;
  }

  /**
   * Returns {@code true} when the {@link Opportunity} needs a {@code premium-opportunity}.
   */
  public Boolean needsNextOpportunity(Opportunity opportunity) {
    if (!isClosedWon(opportunity)) {
      return false;
    }

    return opportunityContainsStarterProduct(opportunity);
  }

  /**
   * Returns {@code true} when the {@link Opportunity} has been updated to and needs a {@code premium-opportunity}.
   */
  public Boolean needsNextOpportunity(
    Opportunity newOpportunity,
    Opportunity oldOpportunity
  ) {
    if (!isClosedWon(newOpportunity)) {
      return false;
    }

    // Only needs a next Opportunity when the Opportunity is _updated_ to Closed Won
    if (isClosedWon(newOpportunity) && isClosedWon(oldOpportunity)) {
      return false;
    }

    return opportunityContainsStarterProduct(newOpportunity);
  }

  /**
   * Returns {@code true} when the {@link Opportunity} is "Closed Won".
   */
  public Boolean isClosedWon(Opportunity opportunity) {
    return opportunity.IsClosed && opportunity.IsWon;
  }

  private Boolean opportunityContainsStarterProduct(Opportunity opportunity) {
    if (
      opportunity.OpportunityLineItems == null ||
      opportunity.OpportunityLineItems.isEmpty()
    ) {
      return false;
    }

    for (
      OpportunityLineItem opportunityLineItem : opportunity.OpportunityLineItems
    ) {
      if (starterProducts.contains(opportunityLineItem?.Product2?.Name)) {
        return true;
      }
    }

    return false;
  }
}