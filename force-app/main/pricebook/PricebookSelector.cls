/**
 * Retrieves {@link Pricebook2} records.
 */
public inherited sharing virtual class PricebookSelector {
  /**
   * Returns the standard {@link Pricebook2}.
   */
  public virtual Pricebook2 getStandardPricebook() {
    List<Pricebook2> pricebook2s = [
      SELECT Id
      FROM Pricebook2
      WHERE IsStandard = TRUE
      LIMIT 1
    ];
    return (pricebook2s.size() == 1) ? pricebook2s.get(0) : null;
  }
}