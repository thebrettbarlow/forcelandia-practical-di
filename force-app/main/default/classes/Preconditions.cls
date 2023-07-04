/**
 * Convenience methods for a method or constructor to check if it was invoked correctly.
 *
 * Inspired by Guava Preconditions
 * @see https://guava.dev/releases/19.0/api/docs/com/google/common/base/Preconditions.html
 */
public inherited sharing class Preconditions {
  /**
   * Throws an {@link IllegalArgumentException} when the expression is false.
   */
  public static void checkArgument(Boolean expression) {
    if (!expression) {
      throw new IllegalArgumentException();
    }
  }

  /**
   * Throws an {@link IllegalArgumentException} with the error message when the expression is false.
   */
  public static void checkArgument(Boolean expression, String errorMessage) {
    if (!expression) {
      throw new IllegalArgumentException(errorMessage);
    }
  }
}