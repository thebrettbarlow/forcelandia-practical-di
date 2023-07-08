/**
 * Tests for {@link PremiumOpportunityFactory}.
 */
@IsTest(IsParallel=true)
private class PremiumOpportunityFactoryTest {
  @IsTest
  private static void createFor_buildsPremiumOpportunity() {
    Id accountId = SObjectUtil.generateFakeId(Account.SObjectType);
    Id pricebookEntryId = SObjectUtil.generateFakeId(
      PricebookEntry.SObjectType
    );
    List<PricebookEntry> pricebookEntries = new List<PricebookEntry>{
      new PricebookEntry(Id = pricebookEntryId, UnitPrice = 10)
    };
    FakeSelector fakeSelector = new FakeSelector(pricebookEntries);
    PremiumOpportunityFactory.selector = fakeSelector;
    Pricebook2 standardPricebook = new Pricebook2(
      Id = SObjectUtil.generateFakeId(Pricebook2.SObjectType)
    );
    FakePricebookSelector fakePricebookSelector = new FakePricebookSelector(
      standardPricebook
    );
    String stageName = 'stage-name';
    Date today = Date.newInstance(2023, 7, 12);
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      fakePricebookSelector,
      stageName,
      today
    );

    PremiumOpportunity premiumOpportunity = premiumOpportunityFactory.createFor(
      accountId
    );

    Assert.areEqual(accountId, premiumOpportunity.accountId);
    Assert.areEqual(
      'Premium Opportunity - September 2023',
      premiumOpportunity.name
    );
    Assert.areEqual('stage-name', premiumOpportunity.stageName);
    Assert.areEqual(Date.newInstance(2023, 9, 1), premiumOpportunity.closeDate);
    Assert.areEqual(1, premiumOpportunity.unitPricesByPricebookEntryIds.size());
    Assert.areEqual(
      10,
      premiumOpportunity.unitPricesByPricebookEntryIds.get(pricebookEntryId)
    );
  }

  @IsTest
  private static void createFor_stageNameIsNull_throws() {
    PricebookSelector pricebookSelector;
    String stageName;
    Date today;
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      pricebookSelector,
      stageName,
      today
    );
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected a default StageName. Found null'
    );

    try {
      premiumOpportunityFactory.createFor(null);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }

  @IsTest
  private static void createFor_todayIsNull_throws() {
    PricebookSelector pricebookSelector;
    String stageName = 'stage-name';
    Date today;
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      pricebookSelector,
      stageName,
      today
    );
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected a Date representing today to allow for consistent Date operations. Found null'
    );

    try {
      premiumOpportunityFactory.createFor(null);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }

  @IsTest
  private static void createFor_pricebookIdIsNull_throws() {
    Pricebook2 standardPricebook = null;
    FakePricebookSelector fakePricebookSelector = new FakePricebookSelector(
      standardPricebook
    );
    String stageName = 'stage-name';
    Date today = Date.today();
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      fakePricebookSelector,
      stageName,
      today
    );
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected a Pricebook Id to use when querying PricebookEntry records. Found null'
    );

    try {
      premiumOpportunityFactory.createFor(null);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }

  @IsTest
  private static void selector_noRecords_noResults() {
    Id pricebookId = SObjectUtil.generateFakeId(Pricebook2.SObjectType);
    PremiumOpportunityFactory.Selector selector = new PremiumOpportunityFactory.Selector();

    List<PricebookEntry> pricebookEntries = selector.getPricebookEntries(
      pricebookId
    );

    Assert.isTrue(pricebookEntries.isEmpty());
  }

  private class FakeSelector extends PremiumOpportunityFactory.Selector {
    private final List<PricebookEntry> pricebookEntries;

    private FakeSelector(List<PricebookEntry> pricebookEntries) {
      this.pricebookEntries = pricebookEntries;
    }

    private override List<PricebookEntry> getPricebookEntries(Id pricebookId) {
      return pricebookEntries;
    }
  }

  private class FakePricebookSelector extends PricebookSelector {
    private final Pricebook2 standardPricebook;

    private FakePricebookSelector(Pricebook2 standardPricebook) {
      this.standardPricebook = standardPricebook;
    }

    public override Pricebook2 getStandardPricebook() {
      return standardPricebook;
    }
  }
}