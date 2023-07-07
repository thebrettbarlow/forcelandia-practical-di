/**
 * Tests for {@link OpportunityConstants}.
 */
@IsTest(IsParallel=true)
private class OpportunityConstantsTest {
  @IsTest
  private static void accessEachField_returnsNonNullValue() {
    Assert.isNotNull(OpportunityConstants.PREMIUM_PRODUCTS);
  }
}