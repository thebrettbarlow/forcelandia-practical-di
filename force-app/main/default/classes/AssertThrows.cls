/**
 * Utility to assert that exceptions are thrown.
 *
 * Inspired by JUnit {@code assertThrows()}
 * @see https://github.com/junit-team/junit5/blob/main/junit-jupiter-api/src/main/java/org/junit/jupiter/api/AssertThrows.java
 */
public inherited sharing class AssertThrows {
  /**
   * An instance of verifying than a code execution has thrown an exception.
   */
  public class Throwing {
    private Boolean hasThrown = false;
    private Boolean isNotThrowing = false;

    private Type exceptionClass;
    private String errorMessage;
    private String assertMessage;

    /**
     * Throws a fatal error.
     *
     * This can be used to make a test fail when code that should have thrown does not throw.
     *
     * It's likely that this line will never get code coverage and that's okay.
     */
    public void shouldHaveThrown() {
      Assert.fail(assertMessage);
    }

    /**
     * Verifies the exception was thrown in the expected way.
     */
    public void threw(Exception e) {
      Assert.isFalse(
        isNotThrowing,
        String.format(
          'Did not expect an exception to be thrown, but is actually throwing {0}: {1}',
          new List<Object>{ e.getTypeName(), e.getMessage() }
        )
      );

      hasThrown = true;
      Assert.isInstanceOfType(
        e,
        exceptionClass,
        String.format(
          'Incorrect exception type. Found: {0}: {1}',
          new List<Object>{ e.getTypeName(), e.getMessage() }
        )
      );

      // Specifically checking for non-null because error message may be an empty string
      if (errorMessage != null) {
        Assert.areEqual(errorMessage, e.getMessage());
      }
    }

    /**
     * Verifies that an exception was not thrown.
     *
     * Call this after the try / catch used to run the code that should not have thrown an
     * exception. Put this in the "assert" section of the arrange / act / assert test method
     * structure.
     */
    public void assertHasNotThrown() {
      Assert.isFalse(hasThrown, assertMessage);
    }

    /**
     * Verifies that an exception was thrown.
     *
     * Call this after the try / catch used to run the code that should thrown an exception. Put
     * this in the "assert" section of the arrange / act / assert test method structure.
     */
    public void assertHasThrown() {
      Assert.isTrue(hasThrown, assertMessage);
    }

    @TestVisible
    private Type getExceptionClass() {
      return exceptionClass;
    }

    @TestVisible
    private String getErrorMessage() {
      return errorMessage;
    }

    @TestVisible
    private String getAssertMessage() {
      return assertMessage;
    }

    /**
     * Private constructor.
     *
     * Use the {@link AssertThrows.with} static methods to construct this.
     */
    private Throwing() {
    }
  }

  /**
   * Builds and returns an object to verify a specific type of exception will be thrown.
   */
  public static Throwing with(Type exceptionClass) {
    Throwing throwing = new Throwing();
    throwing.exceptionClass = exceptionClass;
    throwing.assertMessage = 'Should have thrown ' + exceptionClass.getName();

    return throwing;
  }

  /**
   * Builds and returns an object to verify a specific type of exception and error message will be
   * thrown.
   */
  public static Throwing with(Type exceptionClass, String errorMessage) {
    Throwing throwing = with(exceptionClass);
    throwing.errorMessage = errorMessage;
    throwing.assertMessage += ' with message: ' + errorMessage;

    return throwing;
  }

  /**
   * Builds and returns an object to verify that an exception was not thrown.
   */
  public static Throwing doesNotThrow() {
    Throwing throwing = new Throwing();
    throwing.isNotThrowing = true;
    throwing.exceptionClass = Exception.class;
    throwing.assertMessage = 'Should not have thrown any exception';

    return throwing;
  }
}