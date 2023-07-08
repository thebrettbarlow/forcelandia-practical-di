/**
 * Tests for {@link AccountConstants}.
 */
@IsTest(IsParallel=true)
private class AccountConstantsTest {
  @IsTest
  private static void accessEachField_returnsNonNullValue() {
    Assert.isNotNull(AccountConstants.PREMIUM_CUSTOMER_TYPES);
  }
}