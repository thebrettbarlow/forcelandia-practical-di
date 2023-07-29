/**
 * Tests for {@link AssertThrows}.
 */
@IsTest(IsParallel=true)
private class AssertThrowsTest {
  @IsTest
  private static void with_exceptionClass_hasSpecificExceptionClass() {
    Type exceptionClass = IllegalArgumentException.class;

    AssertThrows.Throwing execution = AssertThrows.with(exceptionClass);

    Assert.areEqual(IllegalArgumentException.class, execution.getExceptionClass());
    Assert.areEqual(
      'Should have thrown System.IllegalArgumentException',
      execution.getAssertMessage()
    );
  }

  @IsTest
  private static void with_errorMessage_hasSpecificErrorMessage() {
    String errorMessage = 'it failed';

    AssertThrows.Throwing execution = AssertThrows.with(
      IllegalArgumentException.class,
      errorMessage
    );

    Assert.areEqual('it failed', execution.getErrorMessage());
    Assert.areEqual(
      'Should have thrown System.IllegalArgumentException with message: it failed',
      execution.getAssertMessage()
    );
  }

  @IsTest
  private static void throwing_doesNotThrow() {
    AssertThrows.Throwing throwing = AssertThrows.doesNotThrow();

    try {
      Integer i = 1 + 1;
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasNotThrown();
  }

  @IsTest
  private static void throwing_throws() {
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'missing parameter'
    );

    try {
      throw new IllegalArgumentException('missing parameter');
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }
}