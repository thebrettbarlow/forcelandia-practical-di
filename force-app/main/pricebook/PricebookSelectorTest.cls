/**
 * Tests for {@link PricebookSelector}.
 */
@IsTest(IsParallel=true)
private class PricebookSelectorTest {
  @IsTest
  private static void getStandardPricebook_returnsNullInTest() {
    PricebookSelector pricebookSelector = new PricebookSelector();

    Pricebook2 standardPricebook = pricebookSelector.getStandardPricebook();

    // Happens because tests should use Test.getStandardPricebookId() to get the standard Pricebook Id
    Assert.isNull(standardPricebook);
  }
}