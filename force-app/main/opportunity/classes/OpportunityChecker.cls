/**
 * Returns information about the state of an {@link Opportunity} record.
 */
public inherited sharing class OpportunityChecker {
  /**
   * Returns {@code true} when an {@link Opportunity} has a standard product.
   */
  public Boolean hasStandardProduct(Opportunity opportunity) {
    throw new UnexpectedException('not implemented');
  }

  /**
   * Returns {@code true} when an {@link Opportunity} has a premium product.
   */
  public Boolean hasPremiumProduct(Opportunity opportunity) {
    throw new UnexpectedException('not implemented');
  }

  /**
   * Returns {@code true} when an {@link Opportunity} is "Closed Won".
   */
  public Boolean isClosedWon(Opportunity opportunity) {
    throw new UnexpectedException('not implemented');
  }
}