/**
 * Tests for {@link DatetimeUtil}.
 */
@IsTest(IsParallel=true)
private class DatetimeUtilTest {
  @IsTest
  private static void min_isLessThanToday() {
    System.assert(
      DatetimeUtil.MIN < Datetime.now(),
      'Expected the MIN Datetime to be less than NOW'
    );
  }

  @IsTest
  private static void max_isGreaterThanToday() {
    System.assert(
      DatetimeUtil.MAX > Datetime.now(),
      'Expected the MAX Datetime to be greater than NOW'
    );
  }
}