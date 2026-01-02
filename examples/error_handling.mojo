"""
Example: Result Type for Error Handling

Demonstrates:
- Creating Ok and Err results
- Safe value access
- Pattern matching style
- Type aliases for common cases
"""

from mojo_result import Result, StringResult, IntResult, BoolResult
from mojo_result import ok_string, err_string, ok_int, err_int


fn basic_result_example():
    """Basic Result usage."""
    print("=== Basic Result Type ===")

    # Success case
    var success = Result[Int, String].ok(42, "")
    print("Success result created")

    if success.is_ok():
        print("Value: " + String(success.value()))

    # Error case
    var failure = Result[Int, String].err("not found", 0)
    print("Error result created")

    if failure.is_err():
        print("Error: " + failure.error())

    print("")


fn division_example():
    """Practical example: safe division."""
    print("=== Safe Division ===")

    fn divide(a: Int, b: Int) -> IntResult:
        if b == 0:
            return err_int("division by zero")
        return ok_int(a // b)

    # Success case
    var result1 = divide(10, 2)
    if result1.is_ok():
        print("10 / 2 = " + String(result1.value()))

    # Error case
    var result2 = divide(10, 0)
    if result2.is_err():
        print("10 / 0 = Error: " + result2.error())

    print("")


fn unwrap_or_example():
    """Safe unwrapping with defaults."""
    print("=== Unwrap with Default ===")

    fn find_user(id: String) -> StringResult:
        if id == "123":
            return ok_string("Alice")
        return err_string("user not found")

    # Found user
    var user1 = find_user("123")
    var name1 = user1.unwrap_or("Unknown")
    print("User 123: " + name1)

    # Not found - uses default
    var user2 = find_user("999")
    var name2 = user2.unwrap_or("Unknown")
    print("User 999: " + name2)

    print("")


fn expect_example() raises:
    """Expect: unwrap or raise with message."""
    print("=== Expect (raises on error) ===")

    fn get_config(key: String) -> StringResult:
        if key == "PORT":
            return ok_string("8080")
        return err_string("key not found: " + key)

    # Success - returns value
    var port = get_config("PORT")
    var port_val = port.expect("PORT config required")
    print("PORT: " + port_val)

    # Error - would raise with message
    # var missing = get_config("MISSING")
    # var val = missing.expect("MISSING config required")  # Raises!

    print("expect() raises on error with custom message")
    print("")


fn chaining_example():
    """Chain operations on results."""
    print("=== Chaining Operations ===")

    fn parse_int(s: String) -> IntResult:
        if s == "42":
            return ok_int(42)
        return err_int("invalid number")

    fn double(n: Int) -> IntResult:
        return ok_int(n * 2)

    # Parse and transform
    var result = parse_int("42")
    if result.is_ok():
        var doubled = double(result.value())
        print('parse("42") -> double = ' + String(doubled.value()))

    # Error propagates
    var bad = parse_int("abc")
    if bad.is_err():
        print('parse("abc") -> Error: ' + bad.error())

    print("")


fn pattern_matching_style():
    """Pattern matching style usage."""
    print("=== Pattern Matching Style ===")

    fn process(input: String) -> StringResult:
        if len(input) > 0:
            return ok_string("processed: " + input)
        return err_string("empty input")

    var result = process("hello")

    # Boolean conversion
    if result:
        var value = result.value()
        print("Success: " + value)
    else:
        var error = result.error()
        print("Error: " + error)

    print("")


fn main() raises:
    print("mojo-result: Type-Safe Error Handling\n")

    basic_result_example()
    division_example()
    unwrap_or_example()
    expect_example()
    chaining_example()
    pattern_matching_style()

    print("=" * 50)
    print("Philosophy:")
    print("  - Errors are values, not exceptions")
    print("  - Make error handling explicit")
    print("  - Provide safe defaults")
    print("  - Compatible with Mojo value semantics")
