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
    String stageName = 'stage-name';
    Id pricebookId = SObjectUtil.generateFakeId(Pricebook2.SObjectType);
    Date today = Date.newInstance(2023, 7, 12);
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      stageName,
      pricebookId,
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
    String stageName;
    Id pricebookId;
    Date today;
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      stageName,
      pricebookId,
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
  private static void createFor_pricebookIdIsNull_throws() {
    String stageName = 'stage-name';
    Id pricebookId;
    Date today;
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      stageName,
      pricebookId,
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
  private static void createFor_pricebookIdIncorrectSObjectType_throws() {
    String stageName = 'stage-name';
    Id pricebookId = SObjectUtil.generateFakeId(Lead.SObjectType);
    Date today;
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      stageName,
      pricebookId,
      today
    );
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected the Pricebook Id to have SObjectType Pricebook2. Found SObjectType Lead'
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
    String stageName = 'stage-name';
    Id pricebookId = SObjectUtil.generateFakeId(Pricebook2.SObjectType);
    Date today;
    PremiumOpportunityFactory premiumOpportunityFactory = new PremiumOpportunityFactory(
      stageName,
      pricebookId,
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
}