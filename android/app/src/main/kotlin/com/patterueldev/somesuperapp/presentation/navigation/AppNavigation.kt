package com.patterueldev.somesuperapp.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.patterueldev.somesuperapp.data.repository.TodoRepository
import com.patterueldev.somesuperapp.presentation.screen.AddEditTodoScreen
import com.patterueldev.somesuperapp.presentation.screen.DashboardScreen
import com.patterueldev.somesuperapp.presentation.screen.TodoDetailScreen
import com.patterueldev.somesuperapp.presentation.screen.TodoListScreen
import com.patterueldev.somesuperapp.presentation.viewmodel.TodoDetailViewModel
import com.patterueldev.somesuperapp.presentation.viewmodel.TodoListViewModel

@Composable
fun AppNavigation(repository: TodoRepository) {
    val navController = rememberNavController()

    // Create ViewModels (in production, use Hilt or ViewModelProvider)
    val todoListViewModel = remember { TodoListViewModel(repository) }
    val todoDetailViewModel = remember { TodoDetailViewModel(repository) }

    NavHost(
        navController = navController,
        startDestination = Route.Dashboard.path
    ) {
        composable(Route.Dashboard.path) {
            DashboardScreen(
                onNavigateToTodoList = {
                    navController.navigate(Route.TodoList.path)
                }
            )
        }

        composable(Route.TodoList.path) {
            val todos by todoListViewModel.todos.collectAsState()

            TodoListScreen(
                todos = todos,
                onNavigateBack = { navController.popBackStack() },
                onNavigateToDetail = { todoId ->
                    navController.navigate(Route.TodoDetail.createRoute(todoId))
                },
                onNavigateToAdd = {
                    navController.navigate(Route.AddEditTodo.createRoute())
                },
                onToggleCompletion = { todoId ->
                    todoListViewModel.toggleCompletion(todoId)
                },
                onDelete = { todoId ->
                    todoListViewModel.deleteTodo(todoId)
                }
            )
        }

        composable(
            route = Route.TodoDetail.path,
            arguments = listOf(navArgument("todoId") { type = NavType.StringType })
        ) { backStackEntry ->
            val todoId = backStackEntry.arguments?.getString("todoId") ?: return@composable
            val todo by todoDetailViewModel.todo.collectAsState()

            // Load todo when screen appears
            remember(todoId) {
                todoDetailViewModel.loadTodo(todoId)
                true
            }

            TodoDetailScreen(
                todo = todo,
                onNavigateBack = { navController.popBackStack() },
                onNavigateToEdit = { id ->
                    navController.navigate(Route.AddEditTodo.createRoute(id))
                },
                onToggleCompletion = { id ->
                    todoDetailViewModel.toggleCompletion(id)
                },
                onDelete = { id ->
                    todoDetailViewModel.deleteTodo(id) {
                        navController.popBackStack()
                    }
                }
            )
        }

        composable(
            route = Route.AddEditTodo.path,
            arguments = listOf(
                navArgument("todoId") {
                    type = NavType.StringType
                    nullable = true
                }
            )
        ) { backStackEntry ->
            val todoId = backStackEntry.arguments?.getString("todoId")
            val existingTodo by todoDetailViewModel.todo.collectAsState()

            // Load existing todo if editing
            remember(todoId) {
                if (todoId != null) {
                    todoDetailViewModel.loadTodo(todoId)
                }
                true
            }

            AddEditTodoScreen(
                existingTodo = if (todoId != null) existingTodo else null,
                onNavigateBack = { navController.popBackStack() },
                onSave = { todo ->
                    if (todoId != null) {
                        todoDetailViewModel.updateTodo(todo)
                    } else {
                        todoListViewModel.addTodo(todo)
                    }
                    navController.popBackStack()
                }
            )
        }
    }
}
