/**
 * Tests for {@link OpportunityChecker}.
 */
@IsTest(IsParallel=true)
private class OpportunityCheckerTest {
  @IsTest
  private static void hasPremiumProduct_opportunityLineItemsContainPremiumProduct_returnsTrue() {
    Set<String> premiumProducts = new Set<String>{ 'premium-product' };
    List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>{
      new OpportunityLineItem(Product2 = new Product2(Name = 'premium-product'))
    };
    OpportunityChecker opportunityChecker = new OpportunityChecker(
      premiumProducts
    );

    Boolean hasPremiumProduct = opportunityChecker.hasPremiumProduct(
      opportunityLineItems
    );

    Assert.isTrue(hasPremiumProduct);
  }

  @IsTest
  private static void hasPremiumProduct_opportunityLineItemsDoesNotContainPremiumProduct_returnsFalse() {
    Set<String> premiumProducts = new Set<String>{ 'premium-product' };
    List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>{
      new OpportunityLineItem(
        Product2 = new Product2(Name = 'not-a-premium-product')
      )
    };
    OpportunityChecker opportunityChecker = new OpportunityChecker(
      premiumProducts
    );

    Boolean hasPremiumProduct = opportunityChecker.hasPremiumProduct(
      opportunityLineItems
    );

    Assert.isFalse(hasPremiumProduct);
  }

  @IsTest
  private static void hasPremiumProduct_opportunityLineItemWithoutProduct_throws() {
    Set<String> premiumProducts = new Set<String>{ 'premium-product' };
    Id opportunityLineItemId = SObjectUtil.generateFakeId(
      OpportunityLineItem.SObjectType
    );
    List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>{
      new OpportunityLineItem(Id = opportunityLineItemId)
    };
    OpportunityChecker opportunityChecker = new OpportunityChecker(
      premiumProducts
    );
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      String.format(
        'Expected each OpportunityLineItem to have a Product2.Name. Found null on {0}',
        new List<Object>{ opportunityLineItemId }
      )
    );

    try {
      opportunityChecker.hasPremiumProduct(opportunityLineItems);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }

  @IsTest
  private static void hasPremiumProduct_providedNullValue_throws() {
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected a non-null List<OpportunityLineItem>. Found null'
    );
    Set<String> premiumProducts;
    OpportunityChecker opportunityChecker = new OpportunityChecker(
      premiumProducts
    );

    try {
      opportunityChecker.hasPremiumProduct(null);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }

  @IsTest
  private static void isClosedWon_hasClosedAndWonBooleanFieldsTrue_returnsTrue() {
    Opportunity opportunity = (Opportunity) SObjectUtil.setReadOnlyFields(
      new Opportunity(),
      new Map<String, Object>{ 'IsClosed' => true, 'IsWon' => true }
    );
    Set<String> premiumProducts;
    OpportunityChecker opportunityChecker = new OpportunityChecker(
      premiumProducts
    );

    Boolean isClosedWon = opportunityChecker.isClosedWon(opportunity);

    Assert.isTrue(isClosedWon);
  }

  @IsTest
  private static void isClosedWon_hasWonBooleanFieldFalse_returnsFalse() {
    Opportunity opportunity = (Opportunity) SObjectUtil.setReadOnlyFields(
      new Opportunity(),
      new Map<String, Object>{ 'IsClosed' => true, 'IsWon' => false }
    );
    Set<String> premiumProducts;
    OpportunityChecker opportunityChecker = new OpportunityChecker(
      premiumProducts
    );

    Boolean isClosedWon = opportunityChecker.isClosedWon(opportunity);

    Assert.isFalse(isClosedWon);
  }

  @IsTest
  private static void isClosedWon_providedNullValue_throws() {
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected a non-null Opportunity. Found null'
    );
    Set<String> premiumProducts;
    OpportunityChecker opportunityChecker = new OpportunityChecker(
      premiumProducts
    );

    try {
      opportunityChecker.isClosedWon(null);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }
}