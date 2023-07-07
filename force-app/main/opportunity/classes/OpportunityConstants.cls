/**
 * Constants related to {@link Opportunity}.
 */
public inherited sharing class OpportunityConstants {
  /**
   * Names of all premium products.
   */
  public static final Set<String> PREMIUM_PRODUCTS {
    get {
      return new Set<String>{ 'Premium', 'Premium (legacy)', 'Unlimited' };
    }
  }
}