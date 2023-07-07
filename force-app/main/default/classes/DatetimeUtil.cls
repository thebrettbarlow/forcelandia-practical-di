/**
 * Utilities for working with {@link Datetime} in Apex.
 */
public with sharing class DatetimeUtil {
  /**
   * The earliest valid {@link Datetime}.
   *
   * The earliest valid date is 1700-01-01T00:00:00Z GMT, or just after midnight on January 1, 1700.
   * @see: https://help.salesforce.com/s/articleView?id=sf.fields_date_range.htm&type=5
   */
  public static final Datetime MIN = Datetime.newInstance(1700, 1, 1, 0, 0, 0);

  /**
   * The latest valid {@link Datetime}.
   *
   * The latest valid date is 4000-12-31T00:00:00Z GMT, or just after midnight on December 31, 4000.
   * @see: https://help.salesforce.com/s/articleView?id=sf.fields_date_range.htm&type=5
   */
  public static final Datetime MAX = Datetime.newInstance(
    4000,
    12,
    31,
    0,
    0,
    0
  );
}