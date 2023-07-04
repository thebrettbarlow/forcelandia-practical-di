/**
 * Performs DML operations on {@link Opportunity} records.
 *
 * Other DML operations have been omitted because insert is the only one needed for the demo.
 */
public inherited sharing class OpportunityWriter {
  /**
   * Inserts {@link Opportunity} records.
   */
  public void databaseInsert(List<Opportunity> opportunities) {
    insert opportunities;
  }
}