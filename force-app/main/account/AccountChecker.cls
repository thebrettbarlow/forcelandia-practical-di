/**
 * Returns information about the state of an {@link Account} record.
 */
public inherited sharing virtual class AccountChecker {
  /**
   * Returns {@code true} when an {@link Account} is a premium customer.
   */
  public virtual Boolean isPremiumCustomer(Account account) {
    throw new UnexpectedException('not implemented');
  }
}