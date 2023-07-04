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
        PREMIUM_OPPORTUNITY_SERVICE,
        OPPORTUNITY_SELECTOR
      );
    }
  }

  private static final PremiumOpportunityService PREMIUM_OPPORTUNITY_SERVICE {
    get {
      return new PremiumOpportunityService(
        OPPORTUNITY_CHECKER,
        OPPORTUNITY_FACTORY,
        OPPORTUNITY_SELECTOR,
        OPPORTUNITY_WRITER
      );
    }
  }

  private static final OpportunityChecker OPPORTUNITY_CHECKER {
    get {
      return new OpportunityChecker(OpportunityConstants.STARTER_PRODUCTS);
    }
  }

  private static final OpportunityFactory OPPORTUNITY_FACTORY {
    get {
      return new OpportunityFactory();
    }
  }

  private static final OpportunitySelector OPPORTUNITY_SELECTOR {
    get {
      return new OpportunitySelector(OpportunityConstants.PREMIUM_PRODUCTS);
    }
  }

  private static final OpportunityWriter OPPORTUNITY_WRITER {
    get {
      return new OpportunityWriter();
    }
  }
}