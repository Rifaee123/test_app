# Result Wrapper Pattern Documentation

## Overview

The `Result<T>` type is a functional programming pattern that makes error handling explicit and type-safe. Instead of throwing exceptions, functions return a `Result` that can be either a `Success` with data or a `Failure` with an exception.

## Benefits

1. **Explicit Error Handling**: Errors are part of the type signature, making it clear that a function can fail
2. **No Try-Catch Blocks**: Eliminates the need for try-catch blocks in calling code
3. **Type Safety**: Compiler ensures you handle both success and failure cases
4. **Functional Composition**: Easy to chain operations with `map` and `flatMap`
5. **Cleaner Code**: More readable and maintainable error handling

## Basic Usage

### Creating Results

```dart
// Success
final success = Result.success(user);

// Failure
final failure = Result.failure(NetworkException('Error message'));
```

### Handling Results with `when()`

The `when()` method is the primary way to handle results:

```dart
final result = await repository.getUser(id);

result.when(
  onSuccess: (user) {
    print('Got user: ${user.name}');
  },
  onFailure: (exception) {
    print('Error: ${exception.message}');
  },
);
```

### Conditional Handling

```dart
// Execute only on success
result.whenSuccess((user) {
  print('User: ${user.name}');
});

// Execute only on failure
result.whenFailure((exception) {
  showError(exception.message);
});
```

### Extracting Values

```dart
// Get value or provide default
final user = result.getOrElse(defaultUser);

// Get value or null
final user = result.getOrNull();

// Get value or throw exception
final user = result.getOrThrow();

// Get exception or null
final exception = result.getExceptionOrNull();
```

### Checking Result Type

```dart
if (result.isSuccess) {
  // Handle success
}

if (result.isFailure) {
  // Handle failure
}
```

## Advanced Usage

### Mapping Success Values

Transform the success value to a different type:

```dart
final userResult = await repository.getUser(id);

// Map User to String
final nameResult = userResult.map((user) => user.name);
```

### Flat Mapping (Chaining Operations)

Chain operations that return Results:

```dart
final result = await repository.getUser(id)
  .then((userResult) => userResult.flatMap((user) {
    return repository.getUserPosts(user.id);
  }));
```

### Folding Results

Fold both cases into a single value:

```dart
final message = result.fold(
  (exception) => 'Error: ${exception.message}',
  (user) => 'Welcome, ${user.name}!',
);
```

## Real-World Examples

### In Repositories

```dart
class UserRepositoryImpl implements UserRepository {
  final NetworkService _networkService;

  @override
  Future<Result<User>> getUser(String id) async {
    final result = await _networkService.get('/users/$id');

    return result.map((data) => User.fromJson(data));
  }

  @override
  Future<Result<List<User>>> getAllUsers() async {
    final result = await _networkService.get('/users');

    return result.map((data) {
      final list = data as List;
      return list.map((json) => User.fromJson(json)).toList();
    });
  }
}
```

### In Use Cases

```dart
class GetUserUseCase {
  final UserRepository _repository;

  Future<Result<User>> execute(String userId) {
    return _repository.getUser(userId);
  }
}
```

### In BLoCs

```dart
Future<void> _onLoadUserRequested(
  LoadUserRequested event,
  Emitter<UserState> emit,
) async {
  emit(UserLoading());

  final result = await _getUserUseCase.execute(event.userId);

  result.when(
    onSuccess: (user) => emit(UserLoaded(user)),
    onFailure: (exception) {
      if (exception is ServerException && exception.statusCode == 404) {
        emit(UserNotFound());
      } else {
        emit(UserError(exception.message));
      }
    },
  );
}
```

### In Interactors

```dart
class UserInteractor {
  final GetUserUseCase _getUserUseCase;
  final UserNavigation _navigation;

  Future<Result<User>> loadUser(String userId) async {
    final result = await _getUserUseCase.execute(userId);

    result.whenSuccess((user) {
      _navigation.goToUserProfile(user);
    });

    return result;
  }
}
```

## Async Extensions

The library provides extensions for `Future<Result<T>>`:

### Async Mapping

```dart
final result = await repository.getUser(id)
  .mapAsync((user) async {
    // Perform async transformation
    return await processUser(user);
  });
```

### Async When

```dart
await repository.getUser(id).whenAsync(
  onSuccess: (user) async {
    await saveToCache(user);
  },
  onFailure: (exception) async {
    await logError(exception);
  },
);
```

## Pattern Matching

The `Result` type uses Dart's sealed classes for exhaustive pattern matching:

```dart
switch (result) {
  case Success(:final data):
    print('Success: $data');
  case Failure(:final exception):
    print('Failure: ${exception.message}');
}
```

## Comparison with Try-Catch

### Before (Try-Catch)

```dart
Future<User?> getUser(String id) async {
  try {
    final data = await _networkService.get('/users/$id');
    return User.fromJson(data);
  } on ServerException catch (e) {
    if (e.statusCode == 404) {
      return null;
    }
    rethrow;
  } on NetworkException {
    rethrow;
  }
}

// Calling code
try {
  final user = await repository.getUser(id);
  if (user != null) {
    emit(UserLoaded(user));
  } else {
    emit(UserNotFound());
  }
} on ServerException catch (e) {
  emit(UserError(e.message));
} on NetworkException catch (e) {
  emit(UserError(e.message));
}
```

### After (Result Wrapper)

```dart
Future<Result<User?>> getUser(String id) async {
  final result = await _networkService.get('/users/$id');
  return result.map((data) => User.fromJson(data));
}

// Calling code
final result = await repository.getUser(id);
result.when(
  onSuccess: (user) {
    if (user != null) {
      emit(UserLoaded(user));
    } else {
      emit(UserNotFound());
    }
  },
  onFailure: (exception) => emit(UserError(exception.message)),
);
```

## Best Practices

1. **Always Handle Both Cases**: Use `when()` to ensure you handle both success and failure
2. **Don't Mix Patterns**: If using Result, don't throw exceptions from the same layer
3. **Map Early**: Transform data as close to the source as possible
4. **Keep It Simple**: Don't over-nest `flatMap` operations
5. **Use Type Parameters**: Be specific with your Result types (e.g., `Result<User>` not `Result<dynamic>`)
6. **Document Failure Cases**: Document what exceptions can be in the Failure

## Migration Guide

### Step 1: Update Return Types

```dart
// Before
Future<User> getUser(String id);

// After
Future<Result<User>> getUser(String id);
```

### Step 2: Replace Throws with Failures

```dart
// Before
throw NetworkException('Error');

// After
return Result.failure(NetworkException('Error'));
```

### Step 3: Replace Try-Catch with when()

```dart
// Before
try {
  final user = await repository.getUser(id);
  emit(UserLoaded(user));
} catch (e) {
  emit(UserError(e.toString()));
}

// After
final result = await repository.getUser(id);
result.when(
  onSuccess: (user) => emit(UserLoaded(user)),
  onFailure: (e) => emit(UserError(e.message)),
);
```

## Common Patterns

### Handling Nullable Success Values

```dart
result.when(
  onSuccess: (user) {
    if (user != null) {
      // User found
    } else {
      // User not found (valid case)
    }
  },
  onFailure: (exception) {
    // Network or server error
  },
);
```

### Chaining Multiple Operations

```dart
final result = await repository.getUser(id)
  .then((r) => r.flatMap((user) => repository.getUserPosts(user.id)))
  .then((r) => r.map((posts) => posts.length));
```

### Converting to UI State

```dart
final state = result.fold(
  (exception) => ErrorState(exception.message),
  (user) => LoadedState(user),
);
emit(state);
```

## API Reference

### Result<T>

- `Result.success(T data)` - Create a successful result
- `Result.failure(NetworkException exception)` - Create a failed result
- `when<R>({onSuccess, onFailure})` - Handle both cases
- `whenSuccess(callback)` - Execute only on success
- `whenFailure(callback)` - Execute only on failure
- `map<R>(mapper)` - Transform success value
- `flatMap<R>(mapper)` - Chain operations
- `getOrElse(defaultValue)` - Get value or default
- `getOrNull()` - Get value or null
- `getOrThrow()` - Get value or throw
- `getExceptionOrNull()` - Get exception or null
- `isSuccess` - Check if success
- `isFailure` - Check if failure

### Extensions

- `fold<R>(onFailure, onSuccess)` - Fold into single value
- `mapAsync<R>(mapper)` - Async map (on Future<Result<T>>)
- `whenAsync({onSuccess, onFailure})` - Async when (on Future<Result<T>>)
