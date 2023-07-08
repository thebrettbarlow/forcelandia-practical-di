/**
 * Tests for {@link OpportunityTriggerHandler}.
 */
@IsTest(IsParallel=true)
private class OpportunityTriggerHandlerTest {
  @IsTest
  private static void onBeforeInsert_noOp() {
    AccountChecker accountChecker;
    OpportunityChecker opportunityChecker;
    PremiumOpportunityFactory premiumOpportunityFactory;
    PremiumOpportunityService premiumOpportunityService;
    OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler(
      accountChecker,
      opportunityChecker,
      premiumOpportunityFactory,
      premiumOpportunityService
    );

    opportunityTriggerHandler.onBeforeInsert(null);
  }

  @IsTest
  private static void onBeforeUpdate_noOp() {
    AccountChecker accountChecker;
    OpportunityChecker opportunityChecker;
    PremiumOpportunityFactory premiumOpportunityFactory;
    PremiumOpportunityService premiumOpportunityService;
    OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler(
      accountChecker,
      opportunityChecker,
      premiumOpportunityFactory,
      premiumOpportunityService
    );

    opportunityTriggerHandler.onBeforeUpdate(null, null);
  }

  @IsTest
  private static void onBeforeDelete_noOp() {
    AccountChecker accountChecker;
    OpportunityChecker opportunityChecker;
    PremiumOpportunityFactory premiumOpportunityFactory;
    PremiumOpportunityService premiumOpportunityService;
    OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler(
      accountChecker,
      opportunityChecker,
      premiumOpportunityFactory,
      premiumOpportunityService
    );

    opportunityTriggerHandler.onBeforeDelete(null);
  }

  @IsTest
  private static void onAfterInsert_closedWonNotPremiumCustomerNotPremiumProduct_createsPremiumOpportunity() {
    List<Boolean> isClosedWonResults = new List<Boolean>{ true };
    List<Boolean> isPremiumCustomerResults = new List<Boolean>{ false };
    List<Boolean> hasPremiumProductResults = new List<Boolean>{ false };
    PremiumOpportunity premiumOpportunity = PremiumOpportunity.newBuilder()
      .setName('test-premium-opportunity')
      .build();
    List<Opportunity> opportunities = new List<Opportunity>{
      new Opportunity()
    };
    FakeSelector fakeSelector = new FakeSelector(opportunities);
    OpportunityTriggerHandler.selector = fakeSelector;
    FakeAccountChecker fakeAccountChecker = new FakeAccountChecker(
      isPremiumCustomerResults
    );
    FakeOpportunityChecker opportunityChecker = new FakeOpportunityChecker(
      hasPremiumProductResults,
      isClosedWonResults
    );
    FakePremiumOpportunityFactory fakePremiumOpportunityFactory = new FakePremiumOpportunityFactory(
      premiumOpportunity
    );
    FakePremiumOpportunityService fakePremiumOpportunityService = new FakePremiumOpportunityService();
    OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler(
      fakeAccountChecker,
      opportunityChecker,
      fakePremiumOpportunityFactory,
      fakePremiumOpportunityService
    );

    opportunityTriggerHandler.onAfterInsert(null);

    Assert.areEqual(
      1,
      fakePremiumOpportunityService.processedPremiumOpportunities.size()
    );
    Assert.areEqual(
      'test-premium-opportunity',
      fakePremiumOpportunityService.processedPremiumOpportunities[0].name
    );
  }

  @IsTest
  private static void onAfterUpdate_updatedToClosedWonNotPremiumCustomerNotPremiumProduct_createsPremiumOpportunity() {
    List<Boolean> isClosedWonResults = new List<Boolean>{ false, true };
    List<Boolean> isPremiumCustomerResults = new List<Boolean>{ false };
    List<Boolean> hasPremiumProductResults = new List<Boolean>{ false };
    PremiumOpportunity premiumOpportunity = PremiumOpportunity.newBuilder()
      .setName('test-premium-opportunity')
      .build();
    Opportunity opportunity = new Opportunity(
      Id = SObjectUtil.generateFakeId(Opportunity.SObjectType)
    );
    List<Opportunity> opportunities = new List<Opportunity>{ opportunity };
    Map<Id, Opportunity> oldSObjectsByIds = new Map<Id, Opportunity>(
      opportunities
    );
    FakeSelector fakeSelector = new FakeSelector(opportunities);
    OpportunityTriggerHandler.selector = fakeSelector;
    FakeAccountChecker fakeAccountChecker = new FakeAccountChecker(
      isPremiumCustomerResults
    );
    FakeOpportunityChecker opportunityChecker = new FakeOpportunityChecker(
      hasPremiumProductResults,
      isClosedWonResults
    );
    FakePremiumOpportunityFactory fakePremiumOpportunityFactory = new FakePremiumOpportunityFactory(
      premiumOpportunity
    );
    FakePremiumOpportunityService fakePremiumOpportunityService = new FakePremiumOpportunityService();
    OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler(
      fakeAccountChecker,
      opportunityChecker,
      fakePremiumOpportunityFactory,
      fakePremiumOpportunityService
    );

    opportunityTriggerHandler.onAfterUpdate(null, oldSObjectsByIds);

    Assert.areEqual(
      1,
      fakePremiumOpportunityService.processedPremiumOpportunities.size()
    );
    Assert.areEqual(
      'test-premium-opportunity',
      fakePremiumOpportunityService.processedPremiumOpportunities[0].name
    );
  }

  @IsTest
  private static void onAfterDelete_noOp() {
    AccountChecker accountChecker;
    OpportunityChecker opportunityChecker;
    PremiumOpportunityFactory premiumOpportunityFactory;
    PremiumOpportunityService premiumOpportunityService;
    OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler(
      accountChecker,
      opportunityChecker,
      premiumOpportunityFactory,
      premiumOpportunityService
    );

    opportunityTriggerHandler.onAfterDelete(null);
  }

  @IsTest
  private static void onAfterUndelete_notClosedWon_doesNothing() {
    List<Boolean> isClosedWonResults = new List<Boolean>{ false };
    List<Opportunity> opportunities = new List<Opportunity>{
      new Opportunity()
    };
    FakeSelector fakeSelector = new FakeSelector(opportunities);
    OpportunityTriggerHandler.selector = fakeSelector;
    AccountChecker accountChecker;
    FakeOpportunityChecker opportunityChecker = new FakeOpportunityChecker(
      new List<Boolean>(),
      isClosedWonResults
    );
    PremiumOpportunityFactory premiumOpportunityFactory;
    FakePremiumOpportunityService fakePremiumOpportunityService = new FakePremiumOpportunityService();
    OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler(
      accountChecker,
      opportunityChecker,
      premiumOpportunityFactory,
      fakePremiumOpportunityService
    );

    opportunityTriggerHandler.onAfterUndelete(null);

    Assert.isTrue(
      fakePremiumOpportunityService.processedPremiumOpportunities.isEmpty(),
      'Expected no Premium Opportunity objects to have been processed'
    );
  }

  @IsTest
  private static void selector_noRecords_noResults() {
    OpportunityTriggerHandler.Selector selector = new OpportunityTriggerHandler.Selector();

    List<Opportunity> opportunities = selector.getOpportunities(
      new List<SObject>()
    );

    Assert.isTrue(opportunities.isEmpty());
  }

  private class FakeSelector extends OpportunityTriggerHandler.Selector {
    private final List<Opportunity> opportunities;

    private FakeSelector(List<Opportunity> opportunities) {
      this.opportunities = opportunities;
    }

    private override List<Opportunity> getOpportunities(
      List<SObject> sobjects
    ) {
      return opportunities;
    }
  }

  private class FakeAccountChecker extends AccountChecker {
    private final List<Boolean> isPremiumCustomerResults;

    private FakeAccountChecker(List<Boolean> isPremiumCustomerResults) {
      super(null);

      this.isPremiumCustomerResults = isPremiumCustomerResults;
    }

    public override Boolean isPremiumCustomer(Account account) {
      return isPremiumCustomerResults.remove(0);
    }
  }

  private class FakeOpportunityChecker extends OpportunityChecker {
    private final List<Boolean> hasPremiumProductResults;
    private final List<Boolean> isClosedWonResults;

    private FakeOpportunityChecker(
      List<Boolean> hasPremiumProductResults,
      List<Boolean> isClosedWonResults
    ) {
      super(null);

      this.hasPremiumProductResults = hasPremiumProductResults;
      this.isClosedWonResults = isClosedWonResults;
    }

    public override Boolean hasPremiumProduct(
      List<OpportunityLineItem> opportunityLineItems
    ) {
      return hasPremiumProductResults.remove(0);
    }

    public override Boolean isClosedWon(Opportunity opportunity) {
      return isClosedWonResults.remove(0);
    }
  }

  private class FakePremiumOpportunityFactory extends PremiumOpportunityFactory {
    private final PremiumOpportunity premiumOpportunity;

    private FakePremiumOpportunityFactory(
      PremiumOpportunity premiumOpportunity
    ) {
      super(null, null, null);

      this.premiumOpportunity = premiumOpportunity;
    }

    public override PremiumOpportunity createFor(Id accountId) {
      return premiumOpportunity;
    }
  }

  private class FakePremiumOpportunityService extends PremiumOpportunityService {
    private final List<PremiumOpportunity> processedPremiumOpportunities = new List<PremiumOpportunity>();

    private FakePremiumOpportunityService() {
      super(null);
    }

    public override void createPremiumOpportunities(
      List<PremiumOpportunity> premiumOpportunities
    ) {
      processedPremiumOpportunities.addAll(premiumOpportunities);
    }
  }
}