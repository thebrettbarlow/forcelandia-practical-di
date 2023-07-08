/**
 * Constants related to {@link Account}.
 */
public inherited sharing class AccountConstants {
  public static final Set<String> PREMIUM_CUSTOMER_TYPES {
    get {
      return new Set<String>{ 'Gold', 'Platinum', 'Premium (legacy)' };
    }
  }
}