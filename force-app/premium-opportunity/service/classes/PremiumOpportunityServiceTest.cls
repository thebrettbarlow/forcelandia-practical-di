/**
 * Tests for {@link PremiumOpportunityService}.
 */
@IsTest(IsParallel=true)
private class PremiumOpportunityServiceTest {
  @IsTest
  private static void createPremiumOpportunities_accountDoesNotHaveOpenPremiumOpportunity_createsOpportunityAndOpportunityLineItems() {
    Boolean hasPremiumProduct = false;
    Id accountId = SObjectUtil.generateFakeId(Account.SObjectType);
    Id pricebookEntryId = SObjectUtil.generateFakeId(
      PricebookEntry.SObjectType
    );
    List<Opportunity> openOpportunities = new List<Opportunity>{
      new Opportunity(AccountId = accountId)
    };
    FakeSelector fakeSelector = new FakeSelector(openOpportunities);
    FakeWriter fakeWriter = new FakeWriter();
    PremiumOpportunityService.selector = fakeSelector;
    PremiumOpportunityService.writer = fakeWriter;
    FakeOpportunityChecker fakeOpportunityChecker = new FakeOpportunityChecker(
      hasPremiumProduct
    );
    PremiumOpportunityService premiumOpportunityService = new PremiumOpportunityService(
      fakeOpportunityChecker
    );
    List<PremiumOpportunity> premiumOpportunities = new List<PremiumOpportunity>{
      PremiumOpportunity.newBuilder()
        .setAccountId(accountId)
        .addUnitPricesByPricebookEntryIds(pricebookEntryId, 10)
        .build()
    };

    premiumOpportunityService.createPremiumOpportunities(premiumOpportunities);

    Assert.areEqual(1, fakeWriter.insertedOpportunityLists.size());
    Assert.areEqual(1, fakeWriter.insertedOpportunityLists[0].size());
    Assert.areEqual(
      accountId,
      fakeWriter.insertedOpportunityLists[0][0].AccountId
    );
    Assert.areEqual(1, fakeWriter.insertedOpportunityLineItemLists.size());
    Assert.areEqual(1, fakeWriter.insertedOpportunityLineItemLists[0].size());
    Assert.areEqual(
      pricebookEntryId,
      fakeWriter.insertedOpportunityLineItemLists[0][0].PricebookEntryId
    );
  }

  @IsTest
  private static void createPremiumOpportunities_accountHasOpenPremiumOpportunity_doesNothing() {
    Boolean hasPremiumProduct = true;
    Id accountId = SObjectUtil.generateFakeId(Account.SObjectType);
    List<Opportunity> openOpportunities = new List<Opportunity>{
      new Opportunity(AccountId = accountId)
    };
    FakeSelector fakeSelector = new FakeSelector(openOpportunities);
    FakeWriter fakeWriter = new FakeWriter();
    PremiumOpportunityService.selector = fakeSelector;
    PremiumOpportunityService.writer = fakeWriter;
    FakeOpportunityChecker fakeOpportunityChecker = new FakeOpportunityChecker(
      hasPremiumProduct
    );
    PremiumOpportunityService premiumOpportunityService = new PremiumOpportunityService(
      fakeOpportunityChecker
    );
    List<PremiumOpportunity> premiumOpportunities = new List<PremiumOpportunity>{
      PremiumOpportunity.newBuilder().setAccountId(accountId).build()
    };

    premiumOpportunityService.createPremiumOpportunities(premiumOpportunities);

    Assert.areEqual(0, fakeWriter.insertedOpportunityLists.size());
    Assert.areEqual(0, fakeWriter.insertedOpportunityLineItemLists.size());
  }

  @IsTest
  private static void createPremiumOpportunities_hasNoAccountIds_doesNothing() {
    FakeWriter fakeWriter = new FakeWriter();
    PremiumOpportunityService.writer = fakeWriter;
    OpportunityChecker opportunityChecker;
    PremiumOpportunityService premiumOpportunityService = new PremiumOpportunityService(
      opportunityChecker
    );
    List<PremiumOpportunity> premiumOpportunities = new List<PremiumOpportunity>{
      PremiumOpportunity.newBuilder().build()
    };

    premiumOpportunityService.createPremiumOpportunities(premiumOpportunities);

    Assert.areEqual(0, fakeWriter.insertedOpportunityLists.size());
    Assert.areEqual(0, fakeWriter.insertedOpportunityLineItemLists.size());
  }

  @IsTest
  private static void selector_noRecords_noResults() {
    PremiumOpportunityService.Selector selector = new PremiumOpportunityService.Selector();

    List<Opportunity> opportunities = selector.getOpenOpportunities(
      new Set<Id>()
    );

    Assert.isTrue(opportunities.isEmpty());
  }

  @IsTest
  private static void writerInsertOpportunities_noRecords_doesNothing() {
    List<Opportunity> opportunities = new List<Opportunity>();
    PremiumOpportunityService.Writer writer = new PremiumOpportunityService.Writer();
    AssertThrows.Throwing throwing = AssertThrows.doesNotThrow();

    try {
      writer.insertOpportunities(opportunities);
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
  }

  @IsTest
  private static void writerInsertOpportunityLineItems_noRecords_doesNothing() {
    List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
    PremiumOpportunityService.Writer writer = new PremiumOpportunityService.Writer();
    AssertThrows.Throwing throwing = AssertThrows.doesNotThrow();

    try {
      writer.insertOpportunityLineItems(opportunityLineItems);
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
  }

  private class FakeOpportunityChecker extends OpportunityChecker {
    private final Boolean hasPremiumProduct;

    private FakeOpportunityChecker(Boolean hasPremiumProduct) {
      super(null);

      this.hasPremiumProduct = hasPremiumProduct;
    }

    public override Boolean hasPremiumProduct(
      List<OpportunityLineItem> opportunityLineItems
    ) {
      return hasPremiumProduct;
    }
  }

  private class FakeSelector extends PremiumOpportunityService.Selector {
    private final List<Opportunity> openOpportunities;

    private FakeSelector(List<Opportunity> openOpportunities) {
      this.openOpportunities = openOpportunities;
    }

    private override List<Opportunity> getOpenOpportunities(
      Set<Id> accountIds
    ) {
      return openOpportunities;
    }
  }

  private class FakeWriter extends PremiumOpportunityService.Writer {
    private final List<List<Opportunity>> insertedOpportunityLists = new List<List<Opportunity>>();
    private final List<List<OpportunityLineItem>> insertedOpportunityLineItemLists = new List<List<OpportunityLineItem>>();

    private override void insertOpportunities(List<Opportunity> opportunities) {
      insertedOpportunityLists.add(opportunities);
    }

    private override void insertOpportunityLineItems(
      List<OpportunityLineItem> opportunityLineItems
    ) {
      insertedOpportunityLineItemLists.add(opportunityLineItems);
    }
  }
}