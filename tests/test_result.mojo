"""Tests for mojo-result library."""

from testing import assert_true, assert_false, assert_equal
from ..src import (
    Result,
    StringResult,
    IntResult,
    BoolResult,
    ok_string,
    err_string,
    ok_int,
    err_int,
    ok_bool,
    err_bool,
)


# ============================================================
# Basic Result creation tests
# ============================================================


fn test_ok_creation():
    """Test creating Ok results."""
    var result = Result[Int, String].ok(42, "")

    assert_true(result.is_ok(), "Should be Ok")
    assert_false(result.is_err(), "Should not be Err")


fn test_err_creation():
    """Test creating Err results."""
    var result = Result[Int, String].err("error message", 0)

    assert_false(result.is_ok(), "Should not be Ok")
    assert_true(result.is_err(), "Should be Err")


fn test_ok_with_string_value():
    """Test Ok result with String value."""
    var result = Result[String, String].ok("hello", "")

    assert_true(result.is_ok(), "Should be Ok")


fn test_err_with_string_error():
    """Test Err result with String error."""
    var result = Result[Int, String].err("something went wrong", 0)

    assert_true(result.is_err(), "Should be Err")


# ============================================================
# Value access tests
# ============================================================


fn test_value_on_ok() raises:
    """Test accessing value on Ok result."""
    var result = Result[Int, String].ok(42, "")
    var value = result.value()

    assert_equal(value, 42)


fn test_value_on_err_raises():
    """Test that accessing value on Err raises."""
    var result = Result[Int, String].err("error", 0)
    var raised = False

    try:
        var _ = result.value()
    except:
        raised = True

    assert_true(raised, "Should have raised on value() for Err")


fn test_error_on_err() raises:
    """Test accessing error on Err result."""
    var result = Result[Int, String].err("error message", 0)
    var error = result.error()

    assert_equal(error, "error message")


fn test_error_on_ok_raises():
    """Test that accessing error on Ok raises."""
    var result = Result[Int, String].ok(42, "")
    var raised = False

    try:
        var _ = result.error()
    except:
        raised = True

    assert_true(raised, "Should have raised on error() for Ok")


# ============================================================
# unwrap_or tests
# ============================================================


fn test_unwrap_or_on_ok():
    """Test unwrap_or returns value for Ok."""
    var result = Result[Int, String].ok(42, "")
    var value = result.unwrap_or(0)

    assert_equal(value, 42)


fn test_unwrap_or_on_err():
    """Test unwrap_or returns default for Err."""
    var result = Result[Int, String].err("error", 0)
    var value = result.unwrap_or(100)

    assert_equal(value, 100)


fn test_unwrap_or_with_zero_default():
    """Test unwrap_or with zero as default."""
    var result = Result[Int, String].err("error", 0)
    var value = result.unwrap_or(0)

    assert_equal(value, 0)


fn test_unwrap_or_with_string():
    """Test unwrap_or with String values."""
    var ok_result = Result[String, String].ok("hello", "")
    assert_equal(ok_result.unwrap_or("default"), "hello")

    var err_result = Result[String, String].err("error", "")
    assert_equal(err_result.unwrap_or("default"), "default")


# ============================================================
# expect tests
# ============================================================


fn test_expect_on_ok() raises:
    """Test expect returns value for Ok."""
    var result = Result[Int, String].ok(42, "")
    var value = result.expect("should not fail")

    assert_equal(value, 42)


fn test_expect_on_err_raises():
    """Test that expect raises with custom message for Err."""
    var result = Result[Int, String].err("original error", 0)
    var raised = False

    try:
        var _ = result.expect("custom error message")
    except:
        raised = True

    assert_true(raised, "Should have raised on expect() for Err")


fn test_expect_err_on_err() raises:
    """Test expect_err returns error for Err."""
    var result = Result[Int, String].err("error message", 0)
    var error = result.expect_err("should not fail")

    assert_equal(error, "error message")


fn test_expect_err_on_ok_raises():
    """Test that expect_err raises for Ok."""
    var result = Result[Int, String].ok(42, "")
    var raised = False

    try:
        var _ = result.expect_err("custom error message")
    except:
        raised = True

    assert_true(raised, "Should have raised on expect_err() for Ok")


# ============================================================
# Boolean conversion tests
# ============================================================


fn test_bool_ok_is_true():
    """Test that Ok converts to True."""
    var result = Result[Int, String].ok(42, "")

    assert_true(Bool(result), "Ok should be True")


fn test_bool_err_is_false():
    """Test that Err converts to False."""
    var result = Result[Int, String].err("error", 0)

    assert_false(Bool(result), "Err should be False")


fn test_bool_in_if_statement():
    """Test using Result in if statement."""
    var ok_result = Result[Int, String].ok(42, "")
    var err_result = Result[Int, String].err("error", 0)

    var ok_branch_taken = False
    var err_branch_taken = False

    if ok_result:
        ok_branch_taken = True

    if not err_result:
        err_branch_taken = True

    assert_true(ok_branch_taken, "Ok branch should be taken")
    assert_true(err_branch_taken, "Err branch should be taken")


# ============================================================
# String conversion tests
# ============================================================


fn test_str_ok():
    """Test string conversion for Ok."""
    var result = Result[Int, String].ok(42, "")
    var s = str(result)

    assert_equal(s, "Ok(...)")


fn test_str_err():
    """Test string conversion for Err."""
    var result = Result[Int, String].err("error", 0)
    var s = str(result)

    assert_equal(s, "Err(...)")


# ============================================================
# Type alias tests
# ============================================================


fn test_string_result():
    """Test StringResult type alias."""
    var ok = StringResult.ok("value", "")
    var err = StringResult.err("error", "")

    assert_true(ok.is_ok(), "Should be Ok")
    assert_true(err.is_err(), "Should be Err")


fn test_int_result():
    """Test IntResult type alias."""
    var ok = IntResult.ok(42, "")
    var err = IntResult.err("error", 0)

    assert_true(ok.is_ok(), "Should be Ok")
    assert_true(err.is_err(), "Should be Err")


fn test_bool_result():
    """Test BoolResult type alias."""
    var ok = BoolResult.ok(True, "")
    var err = BoolResult.err("error", False)

    assert_true(ok.is_ok(), "Should be Ok")
    assert_true(err.is_err(), "Should be Err")


# ============================================================
# Convenience constructor tests
# ============================================================


fn test_ok_string() raises:
    """Test ok_string convenience constructor."""
    var result = ok_string("hello")

    assert_true(result.is_ok(), "Should be Ok")
    assert_equal(result.value(), "hello")


fn test_err_string() raises:
    """Test err_string convenience constructor."""
    var result = err_string("error")

    assert_true(result.is_err(), "Should be Err")
    assert_equal(result.error(), "error")


fn test_ok_int() raises:
    """Test ok_int convenience constructor."""
    var result = ok_int(42)

    assert_true(result.is_ok(), "Should be Ok")
    assert_equal(result.value(), 42)


fn test_err_int() raises:
    """Test err_int convenience constructor."""
    var result = err_int("division by zero")

    assert_true(result.is_err(), "Should be Err")
    assert_equal(result.error(), "division by zero")


fn test_ok_bool() raises:
    """Test ok_bool convenience constructor."""
    var result = ok_bool(True)

    assert_true(result.is_ok(), "Should be Ok")
    assert_true(result.value(), "Value should be True")


fn test_err_bool() raises:
    """Test err_bool convenience constructor."""
    var result = err_bool("invalid input")

    assert_true(result.is_err(), "Should be Err")
    assert_equal(result.error(), "invalid input")


# ============================================================
# Edge case tests
# ============================================================


fn test_zero_value():
    """Test that zero values work correctly."""
    var result = Result[Int, String].ok(0, "")

    assert_true(result.is_ok(), "Should be Ok even with zero value")
    assert_equal(result.unwrap_or(100), 0)


fn test_empty_string_value():
    """Test that empty string values work correctly."""
    var result = Result[String, String].ok("", "error")

    assert_true(result.is_ok(), "Should be Ok even with empty string")
    assert_equal(result.unwrap_or("default"), "")


fn test_empty_string_error():
    """Test that empty string errors work correctly."""
    var result = Result[Int, String].err("", 0)

    assert_true(result.is_err(), "Should be Err even with empty error string")


fn test_negative_value():
    """Test that negative values work correctly."""
    var result = Result[Int, String].ok(-42, "")

    assert_true(result.is_ok(), "Should be Ok with negative value")
    assert_equal(result.unwrap_or(0), -42)


# ============================================================
# Usage pattern tests
# ============================================================


fn divide(a: Int, b: Int) -> IntResult:
    """Example function returning Result."""
    if b == 0:
        return err_int("division by zero")
    return ok_int(a // b)


fn test_function_returning_result():
    """Test using Result as function return type."""
    var success = divide(10, 2)
    var failure = divide(10, 0)

    assert_true(success.is_ok(), "Division should succeed")
    assert_equal(success.unwrap_or(0), 5)

    assert_true(failure.is_err(), "Division by zero should fail")
    assert_equal(failure.unwrap_or(-1), -1)


fn test_chained_operations():
    """Test chaining Result operations."""
    var result = divide(100, 10)

    # Pattern: check and use
    if result.is_ok():
        var value = result.unwrap_or(0)
        assert_equal(value, 10)
    else:
        # Should not reach here
        assert_false(True, "Should not reach error branch")


# ============================================================
# Main test runner
# ============================================================


fn main() raises:
    """Run all tests."""
    print("Running mojo-result tests...\n")

    # Basic creation tests
    print("Basic creation tests:")
    test_ok_creation()
    print("  [OK] test_ok_creation")

    test_err_creation()
    print("  [OK] test_err_creation")

    test_ok_with_string_value()
    print("  [OK] test_ok_with_string_value")

    test_err_with_string_error()
    print("  [OK] test_err_with_string_error")

    # Value access tests
    print("\nValue access tests:")
    test_value_on_ok()
    print("  [OK] test_value_on_ok")

    test_value_on_err_raises()
    print("  [OK] test_value_on_err_raises")

    test_error_on_err()
    print("  [OK] test_error_on_err")

    test_error_on_ok_raises()
    print("  [OK] test_error_on_ok_raises")

    # unwrap_or tests
    print("\nunwrap_or tests:")
    test_unwrap_or_on_ok()
    print("  [OK] test_unwrap_or_on_ok")

    test_unwrap_or_on_err()
    print("  [OK] test_unwrap_or_on_err")

    test_unwrap_or_with_zero_default()
    print("  [OK] test_unwrap_or_with_zero_default")

    test_unwrap_or_with_string()
    print("  [OK] test_unwrap_or_with_string")

    # expect tests
    print("\nexpect tests:")
    test_expect_on_ok()
    print("  [OK] test_expect_on_ok")

    test_expect_on_err_raises()
    print("  [OK] test_expect_on_err_raises")

    test_expect_err_on_err()
    print("  [OK] test_expect_err_on_err")

    test_expect_err_on_ok_raises()
    print("  [OK] test_expect_err_on_ok_raises")

    # Boolean conversion tests
    print("\nBoolean conversion tests:")
    test_bool_ok_is_true()
    print("  [OK] test_bool_ok_is_true")

    test_bool_err_is_false()
    print("  [OK] test_bool_err_is_false")

    test_bool_in_if_statement()
    print("  [OK] test_bool_in_if_statement")

    # String conversion tests
    print("\nString conversion tests:")
    test_str_ok()
    print("  [OK] test_str_ok")

    test_str_err()
    print("  [OK] test_str_err")

    # Type alias tests
    print("\nType alias tests:")
    test_string_result()
    print("  [OK] test_string_result")

    test_int_result()
    print("  [OK] test_int_result")

    test_bool_result()
    print("  [OK] test_bool_result")

    # Convenience constructor tests
    print("\nConvenience constructor tests:")
    test_ok_string()
    print("  [OK] test_ok_string")

    test_err_string()
    print("  [OK] test_err_string")

    test_ok_int()
    print("  [OK] test_ok_int")

    test_err_int()
    print("  [OK] test_err_int")

    test_ok_bool()
    print("  [OK] test_ok_bool")

    test_err_bool()
    print("  [OK] test_err_bool")

    # Edge case tests
    print("\nEdge case tests:")
    test_zero_value()
    print("  [OK] test_zero_value")

    test_empty_string_value()
    print("  [OK] test_empty_string_value")

    test_empty_string_error()
    print("  [OK] test_empty_string_error")

    test_negative_value()
    print("  [OK] test_negative_value")

    # Usage pattern tests
    print("\nUsage pattern tests:")
    test_function_returning_result()
    print("  [OK] test_function_returning_result")

    test_chained_operations()
    print("  [OK] test_chained_operations")

    print("\n" + "=" * 40)
    print("All mojo-result tests passed!")
    print("=" * 40)
