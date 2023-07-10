/**
 * Represents a Premium {@link Opportunity}.
 */
public inherited sharing class PremiumOpportunity {
  /**
   * Returns a new {@link Builder} to construct a {@link PremiumOpportunity}.
   */
  public static Builder newBuilder() {
    return new Builder();
  }

  /**
   * Name of the Premium {@link Opportunity}.
   */
  public final String name;

  /**
   * Id of the {@link Account} related to this Premium {@link Opportunity}.
   */
  public final Id accountId;

  /**
   * {@link OpportunityStage} of the Premium {@link Opportunity}.
   */
  public final String stageName;

  /**
   * Estimated date this Premium {@link Opportunity} will close.
   */
  public final Date closeDate;

  /**
   * Mapping of unit prices to their {@link PricebookEntry} Ids.
   */
  public final Map<Id, Decimal> unitPricesByPricebookEntryIds;

  /**
   * Builds and returns a new {@link Opportunity} from {@code this}.
   */
  public Opportunity toOpportunity() {
    return new Opportunity(
      Name = name,
      AccountId = accountId,
      StageName = stageName,
      CloseDate = closeDate
    );
  }

  /**
   * Builds and returns the {@link OpportunityLineItem} records from {@code this}.
   */
  public List<OpportunityLineItem> toOpportunityLineItems() {
    List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
    for (Id pricebookEntryId : unitPricesByPricebookEntryIds.keySet()) {
      opportunityLineItems.add(
        new OpportunityLineItem(
          PricebookEntryId = pricebookEntryId,
          Quantity = 1,
          UnitPrice = unitPricesByPricebookEntryIds.get(pricebookEntryId)
        )
      );
    }

    return opportunityLineItems;
  }

  /**
   * Constructs {@link PremiumOpportunity} objects.
   */
  public class Builder {
    private String name = '';
    private Id accountId = null;
    private String stageName = '';
    private Date closeDate = DatetimeUtil.MAX.date();
    private final Map<Id, Decimal> unitPricesByPricebookEntryIds = new Map<Id, Decimal>();

    /**
     * Sets the name of the Premium {@link Opportunity}, returning {@code this} for chaining.
     */
    public Builder setName(String name) {
      this.name = name;
      return this;
    }

    /**
     * Sets the Id of the {@link Account} related to this Premium {@link Opportunity}, returning {@code this} for
     * chaining.
     */
    public Builder setAccountId(Id accountId) {
      this.accountId = accountId;
      return this;
    }

    /**
     * Sets the {@link OpportunityStage} of the Premium {@link Opportunity}, returning {@code this} for chaining.
     */
    public Builder setStageName(String stageName) {
      this.stageName = stageName;
      return this;
    }

    /**
     * Sets the estimated date this Premium {@link Opportunity} will close, returning {@code this} for chaining.
     */
    public Builder setCloseDate(Date closeDate) {
      this.closeDate = closeDate;
      return this;
    }

    /**
     * Adds a unit price with its {@link OpportunityLineItem} Id, returning {@code this} for chaining.
     */
    public Builder addUnitPricesByPricebookEntryIds(
      Id pricebookEntryId,
      Decimal unitPrice
    ) {
      unitPricesByPricebookEntryIds.put(pricebookEntryId, unitPrice);
      return this;
    }

    /**
     * Builds and returns the {@link PremiumOpportunity}.
     */
    public PremiumOpportunity build() {
      return new PremiumOpportunity(
        name,
        accountId,
        stageName,
        closeDate,
        unitPricesByPricebookEntryIds
      );
    }
  }

  private PremiumOpportunity(
    String name,
    Id accountId,
    String stageName,
    Date closeDate,
    Map<Id, Decimal> unitPricesByPricebookEntryIds
  ) {
    this.name = name;
    this.accountId = accountId;
    this.stageName = stageName;
    this.closeDate = closeDate;
    this.unitPricesByPricebookEntryIds = unitPricesByPricebookEntryIds;
  }
}