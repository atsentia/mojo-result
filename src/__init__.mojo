"""
Mojo Result Library

A foundational library providing a standardized Result type for error handling
across all mojo-libs. This enables consistent, type-safe error handling without
relying solely on exceptions.

Features:
- Generic Result[T, E] type for any value/error combinations
- Static factory methods: ok() and err()
- Safe accessors with explicit error handling
- Convenience methods: unwrap_or, expect
- Type aliases for common patterns (StringResult, IntResult, BoolResult)
- Convenience constructors for quick Result creation

Basic Usage:
    from mojo_result import Result

    # Success case
    var success = Result[Int, String].ok(42, "")
    if success.is_ok():
        print(success.value())  # 42

    # Error case
    var failure = Result[Int, String].err("not found", 0)
    if failure.is_err():
        print(failure.error())  # "not found"

    # Safe unwrapping with default
    var value = failure.unwrap_or(0)  # Returns 0

Using Type Aliases:
    from mojo_result import IntResult, ok_int, err_int

    fn divide(a: Int, b: Int) -> IntResult:
        if b == 0:
            return err_int("division by zero")
        return ok_int(a // b)

    var result = divide(10, 2)
    if result.is_ok():
        print("Result:", result.value())  # 5

Pattern Matching Style:
    var result = some_operation()

    # Boolean conversion
    if result:
        var value = result.value()
        # handle success
    else:
        var error = result.error()
        # handle error

    # With expect for simpler code (raises on error)
    var value = result.expect("Operation failed")

Design Philosophy:
- Errors are values, not exceptions
- Make error handling explicit and visible
- Provide safe defaults where possible
- Compatible with Mojo's value semantics
"""

# Core Result type
from .result import (
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
