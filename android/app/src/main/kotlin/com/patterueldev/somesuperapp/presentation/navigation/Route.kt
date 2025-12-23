package com.patterueldev.somesuperapp.presentation.navigation

sealed class Route(val path: String) {
    data object Dashboard : Route("dashboard")
    data object TodoList : Route("todo_list")
    data object TodoDetail : Route("todo_detail/{todoId}") {
        fun createRoute(todoId: String) = "todo_detail/$todoId"
    }
    data object AddEditTodo : Route("add_edit_todo?todoId={todoId}") {
        fun createRoute(todoId: String? = null) = 
            if (todoId != null) "add_edit_todo?todoId=$todoId" else "add_edit_todo"
    }
}
