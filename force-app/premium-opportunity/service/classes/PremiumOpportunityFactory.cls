/**
 * Builds {@link PremiumOpportunity} objects.
 */
public inherited sharing virtual class PremiumOpportunityFactory {
  /**
   * Builds and returns a {@link PremiumOpportunity} for the {@link Account}.
   */
  public virtual PremiumOpportunity createFor(Id accountId) {
    throw new UnexpectedException('not implemented');
  }
}