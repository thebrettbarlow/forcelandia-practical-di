/**
 * Constants related to {@link Opportunity}.
 */
public inherited sharing class OpportunityConstants {
  /**
   * Names of all standard products.
   */
  public static final Set<String> STANDARD_PRODUCTS {
    get {
      return new Set<String>{ 'Free', 'Standard', 'Starter' };
    }
  }

  /**
   * Names of all premium products.
   */
  public static final Set<String> PREMIUM_PRODUCTS {
    get {
      return new Set<String>{ 'Premium', 'Premium (legacy)', 'Unlimited' };
    }
  }
}