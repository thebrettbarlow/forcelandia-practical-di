/**
 * Returns information about the state of an {@link Opportunity} record.
 */
public inherited sharing virtual class OpportunityChecker {
  private final Set<String> premiumProducts;

  public OpportunityChecker(Set<String> premiumProducts) {
    this.premiumProducts = premiumProducts;
  }

  /**
   * Returns {@code true} when an {@link OpportunityLineItem} has a premium product.
   */
  public virtual Boolean hasPremiumProduct(
    List<OpportunityLineItem> opportunityLineItems
  ) {
    Preconditions.checkArgument(
      opportunityLineItems != null,
      String.format(
        'Expected a non-null List<OpportunityLineItem>. Found {0}',
        new List<Object>{ opportunityLineItems }
      )
    );

    Set<String> errorMessages = new Set<String>();
    for (OpportunityLineItem opportunityLineItem : opportunityLineItems) {
      try {
        // This can happen when the caller does not select these fields in their SOQL query
        Preconditions.checkArgument(
          String.isNotBlank(opportunityLineItem?.Product2?.Name),
          String.format(
            'Expected each OpportunityLineItem to have a Product2.Name. Found {0} on {1}',
            new List<Object>{
              opportunityLineItem?.Product2?.Name,
              opportunityLineItem?.Id
            }
          )
        );
      } catch (IllegalArgumentException e) {
        errorMessages.add(e.getMessage());
      }

      if (premiumProducts.contains(opportunityLineItem.Product2.Name)) {
        return true;
      }
    }

    Preconditions.checkArgument(
      errorMessages.isEmpty(),
      String.join(new List<String>(errorMessages), '\n')
    );

    return false;
  }

  /**
   * Returns {@code true} when an {@link Opportunity} is "Closed Won".
   */
  public virtual Boolean isClosedWon(Opportunity opportunity) {
    Preconditions.checkArgument(
      opportunity != null,
      String.format(
        'Expected a non-null Opportunity. Found {0}',
        new List<Object>{ opportunity }
      )
    );

    return opportunity.IsClosed & opportunity.IsWon;
  }
}