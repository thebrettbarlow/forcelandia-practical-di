/**
 * Provides implementations of {@link TriggerHandler}.
 */
public inherited sharing class TriggerHandlerProvider {
  private final Map<SObjectType, TriggerHandler> triggerHandlers;

  public TriggerHandlerProvider(
    Map<SObjectType, TriggerHandler> triggerHandlers
  ) {
    this.triggerHandlers = triggerHandlers;
  }

  /**
   * Returns the {@link TriggerHandler} mapped to the {@link SObjectType}.
   */
  public TriggerHandler get(SObjectType sobjectType) {
    if (!triggerHandlers.containsKey(sobjectType)) {
      throw new IllegalArgumentException(
        String.format(
          'Expected {0} to be mapped to a {1}. Found {2}',
          new List<Object>{
            sobjectType,
            TriggerHandler.class.getName(),
            triggerHandlers.get(sobjectType)
          }
        )
      );
    }

    return triggerHandlers.get(sobjectType);
  }
}