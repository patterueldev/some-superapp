# Koin Integration Guide

This project uses [Koin](https://insert-koin.io/) for dependency injection, providing a lightweight and pragmatic solution for managing dependencies in your Android application.

## What is Koin?

Koin is a pragmatic lightweight dependency injection framework for Kotlin developers. It uses pure Kotlin features (no code generation, no reflection) and provides a simple DSL for declaring dependencies.

## Project Setup

### Dependencies

The following Koin dependencies are included in the project:

```toml
# gradle/libs.versions.toml
[versions]
koin = "3.5.6"

[libraries]
koin-android = { module = "io.insert-koin:koin-android", version.ref = "koin" }
koin-androidx-compose = { module = "io.insert-koin:koin-androidx-compose", version.ref = "koin" }
```

### Application Class

The `SomeSuperApp` class initializes Koin when the application starts:

```kotlin
// app/src/main/kotlin/com/patterueldev/somesuperapp/SomeSuperApp.kt
class SomeSuperApp : Application() {
    override fun onCreate() {
        super.onCreate()
        
        startKoin {
            androidLogger(Level.ERROR)
            androidContext(this@SomeSuperApp)
            modules(appModule)
        }
    }
}
```

Don't forget to register it in `AndroidManifest.xml`:

```xml
<application
    android:name=".SomeSuperApp"
    ...>
```

## Dependency Modules

All dependencies are defined in the `appModule`:

```kotlin
// app/src/main/kotlin/com/patterueldev/somesuperapp/di/AppModule.kt
val appModule = module {
    // Database - Singleton instance
    single { AppDatabase.getInstance(androidContext()) }
    
    // DAOs - Get from database
    single { get<AppDatabase>().todoDao() }
    
    // Repositories - Business logic layer
    single { TodoRepository(get()) }
    
    // ViewModels - Lifecycle aware components
    viewModel { TodoListViewModel(get()) }
    viewModel { TodoDetailViewModel(get()) }
}
```

### Scope Types

- **`single`**: Creates a singleton instance (shared across the app)
- **`factory`**: Creates a new instance every time it's requested
- **`viewModel`**: Creates a ViewModel with proper lifecycle management

## Usage in Composables

Inject ViewModels in your Composable functions using `koinViewModel()`:

```kotlin
@Composable
fun AppNavigation() {
    // Get ViewModels from Koin
    val todoListViewModel: TodoListViewModel = koinViewModel()
    val todoDetailViewModel: TodoDetailViewModel = koinViewModel()
    
    // Use the ViewModels...
}
```

## Usage in Activities

Inject dependencies in activities using the `by inject()` delegate:

```kotlin
class MainActivity : ComponentActivity() {
    private val repository: TodoRepository by inject()
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Use repository...
    }
}
```

## Adding New Dependencies

### 1. Add Repository

```kotlin
val appModule = module {
    single { UserRepository(get()) }
}
```

### 2. Add ViewModel

```kotlin
val appModule = module {
    viewModel { UserViewModel(get()) }
}
```

### 3. Add Factory (new instance each time)

```kotlin
val appModule = module {
    factory { SomeUseCase(get()) }
}
```

## Multiple Modules

For larger apps, you can split dependencies into multiple modules:

```kotlin
val databaseModule = module {
    single { AppDatabase.getInstance(androidContext()) }
    single { get<AppDatabase>().todoDao() }
}

val repositoryModule = module {
    single { TodoRepository(get()) }
}

val viewModelModule = module {
    viewModel { TodoListViewModel(get()) }
    viewModel { TodoDetailViewModel(get()) }
}

// In Application class
startKoin {
    androidLogger(Level.ERROR)
    androidContext(this@SomeSuperApp)
    modules(databaseModule, repositoryModule, viewModelModule)
}
```

## Testing with Koin

### Unit Tests

```kotlin
class TodoViewModelTest : KoinTest {
    
    @get:Rule
    val koinTestRule = KoinTestRule.create {
        modules(module {
            single<TodoRepository> { mockk() }
        })
    }
    
    @Test
    fun `test something`() {
        val repository: TodoRepository by inject()
        val viewModel = TodoListViewModel(repository)
        // Test...
    }
}
```

### Integration Tests

```kotlin
class AppIntegrationTest {
    
    @Before
    fun before() {
        startKoin {
            modules(appModule)
        }
    }
    
    @After
    fun after() {
        stopKoin()
    }
    
    @Test
    fun testSomething() {
        // Test with real dependencies
    }
}
```

## Benefits of Using Koin

1. **Lightweight**: No code generation or reflection
2. **Easy to Learn**: Simple and readable DSL
3. **Compose-friendly**: First-class support for Jetpack Compose
4. **Testable**: Easy to replace dependencies in tests
5. **Kotlin-first**: Built specifically for Kotlin

## Resources

- [Official Documentation](https://insert-koin.io/docs/reference/introduction)
- [Koin for Android](https://insert-koin.io/docs/reference/koin-android/start)
- [Koin for Compose](https://insert-koin.io/docs/reference/koin-compose/compose)

## Migration Notes

### Before Koin

```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Manual instantiation
        val database = AppDatabase.getInstance(applicationContext)
        val repository = TodoRepository(database.todoDao())
        
        setContent {
            val viewModel = remember { TodoListViewModel(repository) }
            // ...
        }
    }
}
```

### After Koin

```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContent {
            // Dependencies injected automatically
            AppNavigation()
        }
    }
}
```

Much cleaner and more maintainable! 🎉

