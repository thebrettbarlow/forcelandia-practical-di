/**
 * Tests for {@link AccountChecker}.
 */
@IsTest(IsParallel=true)
private class AccountCheckerTest {
  @IsTest
  private static void isPremiumCustomer_hasPremiumCustomerType_returnsTrue() {
    Set<String> premiumCustomerTypes = new Set<String>{ 'premium-customer' };
    Account account = new Account(Type = 'premium-customer');
    AccountChecker accountChecker = new AccountChecker(premiumCustomerTypes);

    Boolean isPremiumCustomer = accountChecker.isPremiumCustomer(account);

    Assert.isTrue(isPremiumCustomer);
  }

  @IsTest
  private static void isPremiumCustomer_doesNotHavePremiumCustomerType_returnsFalse() {
    Set<String> premiumCustomerTypes = new Set<String>{ 'premium-customer' };
    Account account = new Account(Type = 'not-a-premium-customer');
    AccountChecker accountChecker = new AccountChecker(premiumCustomerTypes);

    Boolean isPremiumCustomer = accountChecker.isPremiumCustomer(account);

    Assert.isFalse(isPremiumCustomer);
  }

  @IsTest
  private static void isPremiumCustomer_accountIsNull_throws() {
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected a non-null Account. Found null'
    );
    Set<String> premiumCustomerTypes;
    AccountChecker accountChecker = new AccountChecker(premiumCustomerTypes);

    try {
      accountChecker.isPremiumCustomer(null);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }
}