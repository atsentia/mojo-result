# mojo-result

Pure Mojo Result type for explicit error handling.

## Features

- **Generic Result[T, E]** - Any value/error type combination
- **Type Aliases** - StringResult, IntResult, BoolResult
- **Safe Accessors** - Explicit error handling required
- **Convenience Methods** - unwrap_or, expect
- **Value Semantics** - Compatible with Mojo ownership

## Installation

```bash
pixi add mojo-result
```

## Quick Start

### Basic Usage

```mojo
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
```

### Using Type Aliases

```mojo
from mojo_result import IntResult, ok_int, err_int

fn divide(a: Int, b: Int) -> IntResult:
    if b == 0:
        return err_int("division by zero")
    return ok_int(a // b)

var result = divide(10, 2)
if result.is_ok():
    print("Result:", result.value())  # 5
```

### Pattern Matching Style

```mojo
var result = some_operation()

if result:
    var value = result.value()
    # handle success
else:
    var error = result.error()
    # handle error

# With expect (raises on error)
var value = result.expect("Operation failed")
```

## API Reference

| Method | Description |
|--------|-------------|
| `Result.ok(value, default_err)` | Create success result |
| `Result.err(error, default_val)` | Create error result |
| `is_ok()` | Check if success |
| `is_err()` | Check if error |
| `value()` | Get success value |
| `error()` | Get error value |
| `unwrap_or(default)` | Get value or default |
| `expect(msg)` | Get value or raise |

## Type Aliases

| Alias | Type |
|-------|------|
| `StringResult` | `Result[String, String]` |
| `IntResult` | `Result[Int, String]` |
| `BoolResult` | `Result[Bool, String]` |

## Testing

```bash
mojo run tests/test_result.mojo
```

## License

MIT

## Part of mojo-contrib

This library is part of [mojo-contrib](https://github.com/atsentia/mojo-contrib), a collection of pure Mojo libraries.
