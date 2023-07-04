/**
 * Tests for {@link Preconditions}.
 */
@IsTest(IsParallel=true)
private class PreconditionsTest {
  @IsTest
  private static void checkArgument_false_throws() {
    Boolean expression = false;
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class
    );

    try {
      Preconditions.checkArgument(expression);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }

  @IsTest
  private static void checkArgument_true_doesNotThrow() {
    Boolean expression = true;
    AssertThrows.Throwing throwing = AssertThrows.with(Exception.class);

    try {
      Preconditions.checkArgument(expression);
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
  }

  @IsTest
  private static void checkArgument_falseWithErrorMessage_throwsErrorMessage() {
    Boolean expression = false;
    String errorMessage = 'missing value';
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      errorMessage
    );

    try {
      Preconditions.checkArgument(expression, errorMessage);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }

  @IsTest
  private static void checkArgument_trueWithErrorMessage_doesNotThrow() {
    Boolean expression = true;
    String errorMessage = 'missing value';
    AssertThrows.Throwing throwing = AssertThrows.with(
      Exception.class,
      errorMessage
    );

    try {
      Preconditions.checkArgument(expression, errorMessage);
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
  }
}