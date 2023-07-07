/**
 * Tests for {@link PremiumOpportunity}.
 */
@IsTest(IsParallel=true)
private class PremiumOpportunityTest {
  @IsTest
  private static void newBuilder_populateFields_buildsPremiumOpportunity() {
    String name = 'premium-opportunity-name';
    Id accountId = SObjectUtil.generateFakeId(Account.SObjectType);
    String stageName = 'stage-name';
    Date today = Date.today();
    Date closeDate = today;
    Id pricebookEntryId = SObjectUtil.generateFakeId(
      PricebookEntry.SObjectType
    );
    Decimal unitPrice = 10;
    PremiumOpportunity.Builder builder = PremiumOpportunity.newBuilder();

    PremiumOpportunity premiumOpportunity = builder.setName(name)
      .setAccountId(accountId)
      .setStageName(stageName)
      .setCloseDate(closeDate)
      .addUnitPricesByPricebookEntryIds(pricebookEntryId, unitPrice)
      .build();

    Assert.areEqual('premium-opportunity-name', premiumOpportunity.name);
    Assert.areEqual(accountId, premiumOpportunity.accountId);
    Assert.areEqual('stage-name', premiumOpportunity.stageName);
    Assert.areEqual(today, premiumOpportunity.closeDate);
    Assert.areEqual(
      1,
      premiumOpportunity.unitPricesByPricebookEntryIds.keySet().size()
    );
    Assert.areEqual(
      pricebookEntryId,
      new List<Id>(premiumOpportunity.unitPricesByPricebookEntryIds.keySet())[0]
    );
    Assert.areEqual(
      10,
      premiumOpportunity.unitPricesByPricebookEntryIds.get(pricebookEntryId)
    );
  }

  @IsTest
  private static void toOpportunity_buildsOpportunity() {
    Id accountId = SObjectUtil.generateFakeId(Account.SObjectType);
    Date today = Date.today();
    PremiumOpportunity premiumOpportunity = PremiumOpportunity.newBuilder()
      .setName('test-opportunity')
      .setAccountId(accountId)
      .setStageName('stage-name')
      .setCloseDate(today)
      .build();

    Opportunity opportunity = premiumOpportunity.toOpportunity();

    Assert.areEqual('test-opportunity', opportunity.Name);
    Assert.areEqual(accountId, opportunity.AccountId);
    Assert.areEqual('stage-name', opportunity.StageName);
    Assert.areEqual(today, opportunity.CloseDate);
  }

  @IsTest
  private static void toOpportunityLineItems_buildsOpportunityLineItems() {
    Id pricebookEntryId1 = SObjectUtil.generateFakeId(
      PricebookEntry.SObjectType
    );
    Id pricebookEntryId2 = SObjectUtil.generateFakeId(
      PricebookEntry.SObjectType
    );
    Decimal unitPrice = 10;
    PremiumOpportunity premiumOpportunity = PremiumOpportunity.newBuilder()
      .addUnitPricesByPricebookEntryIds(pricebookEntryId1, unitPrice)
      .addUnitPricesByPricebookEntryIds(pricebookEntryId2, unitPrice)
      .build();

    List<OpportunityLineItem> opportunityLineItems = premiumOpportunity.toOpportunityLineItems();

    Assert.areEqual(2, opportunityLineItems.size());
    Assert.areEqual(
      pricebookEntryId1,
      opportunityLineItems[0].PricebookEntryId
    );
    Assert.areEqual(
      pricebookEntryId2,
      opportunityLineItems[1].PricebookEntryId
    );
  }
}