/**
 * Constants related to {@link Opportunity}.
 */
public inherited sharing class OpportunityConstants {
  /**
   * Names of all starter products.
   */
  public static final Set<String> STARTER_PRODUCTS {
    get {
      return new Set<String>{ 'Free', 'Standard' };
    }
  }

  /**
   * Names of all premium products.
   */
  public static final Set<String> PREMIUM_PRODUCTS {
    get {
      return new Set<String>{ 'Unlimited' };
    }
  }
}