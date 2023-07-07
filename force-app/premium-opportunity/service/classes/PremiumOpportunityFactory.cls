/**
 * Builds {@link PremiumOpportunity} objects.
 */
public inherited sharing virtual class PremiumOpportunityFactory {
  @TestVisible
  private static Selector selector = new Selector();

  private final String stageName;
  private final Id pricebookId;
  private final Date today;

  /**
   * List of {@link PricebookEntry} records that will be added to the {@link PremiumOpportunity}.
   *
   * This is initialized the first time it is needed inside of {@link #createFor}.
   */
  private List<PricebookEntry> pricebookEntries;

  public PremiumOpportunityFactory(
    String stageName,
    Id pricebookId,
    Date today
  ) {
    this.stageName = stageName;
    this.pricebookId = pricebookId;
    this.today = today;
  }

  /**
   * Builds and returns a {@link PremiumOpportunity} for the {@link Account}.
   */
  public virtual PremiumOpportunity createFor(Id accountId) {
    Preconditions.checkArgument(
      String.isNotBlank(stageName),
      String.format(
        'Expected a default StageName. Found {0}',
        new List<Object>{ stageName }
      )
    );
    Preconditions.checkArgument(
      String.isNotBlank(pricebookId),
      String.format(
        'Expected a Pricebook Id to use when querying PricebookEntry records. Found {0}',
        new List<Object>{ pricebookId }
      )
    );
    Preconditions.checkArgument(
      pricebookId.getSobjectType() == Pricebook2.SObjectType,
      String.format(
        'Expected the Pricebook Id to have SObjectType {0}. Found SObjectType {1}',
        new List<Object>{ Pricebook2.SObjectType, pricebookId.getSobjectType() }
      )
    );
    Preconditions.checkArgument(
      today != null,
      String.format(
        'Expected a Date representing today to allow for consistent Date operations. Found {0}',
        new List<Object>{ today }
      )
    );

    Date closeDate = today.addMonths(2).toStartOfMonth();
    String formattedDate = Datetime.newInstance(
        closeDate,
        Time.newInstance(0, 0, 0, 0)
      )
      .format('MMMM YYYY');

    PremiumOpportunity.Builder premiumOpportunityBuilder = PremiumOpportunity.newBuilder()
      .setName(
        String.format(
          'Premium Opportunity - {0}',
          new List<Object>{ formattedDate }
        )
      )
      .setAccountId(accountId)
      .setStageName(stageName)
      .setCloseDate(closeDate);

    if (pricebookEntries == null) {
      pricebookEntries = selector.getPricebookEntries(pricebookId);
    }
    for (PricebookEntry pricebookEntry : pricebookEntries) {
      premiumOpportunityBuilder.addUnitPricesByPricebookEntryIds(
        pricebookEntry.Id,
        pricebookEntry.UnitPrice
      );
    }

    return premiumOpportunityBuilder.build();
  }

  /**
   * Retrieves records for {@link PremiumOpportunityFactory}.
   */
  @TestVisible
  private virtual class Selector {
    /**
     * Returns {@link PricebookEntry} records that are in the {@link Pricebook2} based on its Id.
     */
    @TestVisible
    private virtual List<PricebookEntry> getPricebookEntries(Id pricebookId) {
      return [
        SELECT Id, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2Id = :pricebookId
      ];
    }
  }
}