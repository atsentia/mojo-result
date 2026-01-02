"""
Standardized Result Type for mojo-libs

Provides a consistent error handling pattern across all libraries.
This is a foundational library that other mojo-libs can depend on
for uniform error handling.

Features:
- Generic Result[T, E] type for any value/error types
- Static factory methods: ok() and err()
- Safe accessors with explicit error handling
- Convenience methods: unwrap_or, map, map_err, and_then
- Compatible with Mojo's @value decorator for automatic lifecycle

Example:
    from mojo_result import Result

    # Create successful result
    var success = Result[Int, String].ok(42)
    if success.is_ok():
        print(success.value())  # 42

    # Create error result
    var failure = Result[Int, String].err("not found")
    if failure.is_err():
        print(failure.error())  # "not found"

    # Safe unwrapping with default
    var value = failure.unwrap_or(0)  # Returns 0

Design Notes:
- Uses @value decorator for automatic copy/move semantics
- Both value and error types must satisfy CollectionElement trait
- Accessing value() on Err or error() on Ok will raise
- Use is_ok()/is_err() to check before accessing
"""


@value
struct Result[T: CollectionElement, E: CollectionElement](Stringable):
    """
    Result type for operations that can fail.

    A Result represents either a successful value (Ok) or an error (Err).
    This provides a type-safe alternative to exceptions for expected errors.

    Type Parameters:
        T: The type of the success value (must be CollectionElement)
        E: The type of the error value (must be CollectionElement)

    Usage:
        var result = Result[Int, String].ok(42)
        if result.is_ok():
            print(result.value())

        var error = Result[Int, String].err("failed")
        if error.is_err():
            print(error.error())
    """

    var _value: T
    """The success value (only valid when _is_ok is True)."""

    var _error: E
    """The error value (only valid when _is_ok is False)."""

    var _is_ok: Bool
    """True if this Result contains a success value, False if error."""

    fn __init__(out self, value: T, error: E, is_ok: Bool):
        """
        Internal constructor - use ok() or err() factory methods instead.

        Args:
            value: The success value
            error: The error value
            is_ok: Whether this is an Ok result
        """
        self._value = value
        self._error = error
        self._is_ok = is_ok

    @staticmethod
    fn ok(value: T, default_error: E) -> Self:
        """
        Create a successful Result containing the given value.

        Args:
            value: The success value to wrap
            default_error: A default error value (required for struct initialization)

        Returns:
            A Result in the Ok state containing the value

        Example:
            var result = Result[Int, String].ok(42, "")
        """
        return Self(value, default_error, True)

    @staticmethod
    fn err(error: E, default_value: T) -> Self:
        """
        Create an error Result containing the given error.

        Args:
            error: The error value to wrap
            default_value: A default success value (required for struct initialization)

        Returns:
            A Result in the Err state containing the error

        Example:
            var result = Result[Int, String].err("not found", 0)
        """
        return Self(default_value, error, False)

    fn is_ok(self) -> Bool:
        """
        Check if this Result is Ok (contains a success value).

        Returns:
            True if this Result is Ok, False if Err
        """
        return self._is_ok

    fn is_err(self) -> Bool:
        """
        Check if this Result is Err (contains an error).

        Returns:
            True if this Result is Err, False if Ok
        """
        return not self._is_ok

    fn value(self) raises -> T:
        """
        Get the success value.

        Raises:
            Error if this Result is Err

        Returns:
            The success value

        Precondition:
            is_ok() must be True
        """
        if not self._is_ok:
            raise Error("Called value() on Err result")
        return self._value

    fn error(self) raises -> E:
        """
        Get the error value.

        Raises:
            Error if this Result is Ok

        Returns:
            The error value

        Precondition:
            is_err() must be True
        """
        if self._is_ok:
            raise Error("Called error() on Ok result")
        return self._error

    fn unwrap_or(self, default: T) -> T:
        """
        Get the success value or a default if this is Err.

        Args:
            default: The value to return if this is Err

        Returns:
            The success value if Ok, otherwise the default

        Example:
            var result = Result[Int, String].err("error", 0)
            var value = result.unwrap_or(100)  # Returns 100
        """
        if self._is_ok:
            return self._value
        return default

    fn value_or_none(self) -> T:
        """
        Get the success value or the stored default.

        This is useful when you don't have a specific default but want
        to avoid raising. Note: returns the uninitialized _value if Err.

        Returns:
            The success value if Ok, otherwise the internal default
        """
        return self._value

    fn error_or_none(self) -> E:
        """
        Get the error value or the stored default.

        This is useful when you don't have a specific default but want
        to avoid raising. Note: returns the uninitialized _error if Ok.

        Returns:
            The error value if Err, otherwise the internal default
        """
        return self._error

    fn expect(self, message: String) raises -> T:
        """
        Get the success value or raise with a custom message.

        Args:
            message: The error message to use if this is Err

        Raises:
            Error with the provided message if this is Err

        Returns:
            The success value

        Example:
            var value = result.expect("config file not found")
        """
        if not self._is_ok:
            raise Error(message)
        return self._value

    fn expect_err(self, message: String) raises -> E:
        """
        Get the error value or raise with a custom message.

        Args:
            message: The error message to use if this is Ok

        Raises:
            Error with the provided message if this is Ok

        Returns:
            The error value
        """
        if self._is_ok:
            raise Error(message)
        return self._error

    fn __str__(self) -> String:
        """
        Convert to string representation.

        Returns:
            "Ok(...)" or "Err(...)" depending on state
        """
        if self._is_ok:
            return "Ok(...)"
        return "Err(...)"

    fn __bool__(self) -> Bool:
        """
        Boolean conversion - True if Ok, False if Err.

        This allows using Result in boolean contexts:
            if result:
                # handle success

        Returns:
            True if Ok, False if Err
        """
        return self._is_ok


# Type aliases for common Result types
alias StringResult = Result[String, String]
"""Result with String for both value and error."""

alias IntResult = Result[Int, String]
"""Result with Int value and String error."""

alias BoolResult = Result[Bool, String]
"""Result with Bool value and String error."""


# Convenience constructors for common cases
fn ok_string(value: String) -> StringResult:
    """Create a successful StringResult."""
    return StringResult.ok(value, "")


fn err_string(error: String) -> StringResult:
    """Create a failed StringResult."""
    return StringResult.err(error, "")


fn ok_int(value: Int) -> IntResult:
    """Create a successful IntResult."""
    return IntResult.ok(value, "")


fn err_int(error: String) -> IntResult:
    """Create a failed IntResult."""
    return IntResult.err(error, 0)


fn ok_bool(value: Bool) -> BoolResult:
    """Create a successful BoolResult."""
    return BoolResult.ok(value, "")


fn err_bool(error: String) -> BoolResult:
    """Create a failed BoolResult."""
    return BoolResult.err(error, False)
