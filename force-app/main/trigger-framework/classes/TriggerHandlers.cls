/**
 * Implementations of {@link TriggerHandler}.
 */
public inherited sharing class TriggerHandlers {
  /**
   * Mapping of {@link SObjectType} to its {@link TriggerHandler}.
   */
  public static final Map<SObjectType, TriggerHandler> MAPPING {
    get {
      return new Map<SObjectType, TriggerHandler>{
        Opportunity.SObjectType => OPPORTUNITY_TRIGGER_HANDLER
      };
    }
  }

  private static final OpportunityTriggerHandler OPPORTUNITY_TRIGGER_HANDLER {
    get {
      return new OpportunityTriggerHandler(
        ACCOUNT_CHECKER,
        OPPORTUNITY_CHECKER,
        PREMIUM_OPPORTUNITY_FACTORY,
        PREMIUM_OPPORTUNITY_SERVICE
      );
    }
  }

  private static final PremiumOpportunityService PREMIUM_OPPORTUNITY_SERVICE {
    get {
      return new PremiumOpportunityService(OPPORTUNITY_CHECKER);
    }
  }

  private static final PremiumOpportunityFactory PREMIUM_OPPORTUNITY_FACTORY {
    get {
      return new PremiumOpportunityFactory(
        PRICEBOOK_SELECTOR,
        DEFAULT_PREMIUM_OPPORTUNITY_STAGE_NAME,
        TODAY
      );
    }
  }

  private static final AccountChecker ACCOUNT_CHECKER {
    get {
      return new AccountChecker(AccountConstants.PREMIUM_CUSTOMER_TYPES);
    }
  }

  private static final OpportunityChecker OPPORTUNITY_CHECKER {
    get {
      return new OpportunityChecker(OpportunityConstants.PREMIUM_PRODUCTS);
    }
  }

  private static final PricebookSelector PRICEBOOK_SELECTOR {
    get {
      return new PricebookSelector();
    }
  }

  private static final String DEFAULT_PREMIUM_OPPORTUNITY_STAGE_NAME {
    get {
      return 'Prospecting';
    }
  }

  private static final Date TODAY {
    get {
      return Date.today();
    }
  }
}