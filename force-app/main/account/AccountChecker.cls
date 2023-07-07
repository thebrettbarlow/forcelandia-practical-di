/**
 * Returns information about the state of an {@link Account} record.
 */
public inherited sharing virtual class AccountChecker {
  private final Set<String> premiumCustomerTypes;

  public AccountChecker(Set<String> premiumCustomerTypes) {
    this.premiumCustomerTypes = premiumCustomerTypes;
  }

  /**
   * Returns {@code true} when an {@link Account} is a premium customer.
   */
  public virtual Boolean isPremiumCustomer(Account account) {
    Preconditions.checkArgument(
      account != null,
      String.format(
        'Expected a non-null Account. Found {0}',
        new List<Object>{ account }
      )
    );

    return premiumCustomerTypes.contains(account.Type);
  }
}