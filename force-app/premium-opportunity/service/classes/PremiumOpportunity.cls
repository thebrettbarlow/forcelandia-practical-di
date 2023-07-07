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
   * Builds and returns a new {@link Opportunity} from {@code this}.
   */
  public Opportunity toOpportunity() {
    return null;
  }

  /**
   * Builds and returns the {@link OpportunityLineItem} records from {@code this}.
   */
  public List<OpportunityLineItem> toOpportunityLineItems() {
    return null;
  }

  /**
   * Constructs {@link PremiumOpportunity} objects.
   */
  public class Builder {
    private String name = '';
    private Id accountId = null;
    private String stageName = '';
    private Date closeDate = DatetimeUtil.MAX.date();

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
     * Builds and returns the {@link PremiumOpportunity}.
     */
    public PremiumOpportunity build() {
      return new PremiumOpportunity(name, accountId, stageName, closeDate);
    }
  }

  private PremiumOpportunity(
    String name,
    Id accountId,
    String stageName,
    Date closeDate
  ) {
    this.name = name;
    this.accountId = accountId;
    this.stageName = stageName;
    this.closeDate = closeDate;
  }
}