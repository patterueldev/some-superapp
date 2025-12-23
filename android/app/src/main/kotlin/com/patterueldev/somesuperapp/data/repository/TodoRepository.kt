package com.patterueldev.somesuperapp.data.repository

import com.patterueldev.somesuperapp.data.local.TodoDao
import com.patterueldev.somesuperapp.data.mapper.toDomain
import com.patterueldev.somesuperapp.data.mapper.toEntity
import com.patterueldev.somesuperapp.domain.model.Todo
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.util.Date

class TodoRepository(private val todoDao: TodoDao) {
    
    fun getAllTodos(): Flow<List<Todo>> {
        return todoDao.getAllTodos().map { entities ->
            entities.map { it.toDomain() }
        }
    }

    suspend fun getTodoById(id: String): Todo? {
        return todoDao.getTodoById(id)?.toDomain()
    }

    suspend fun insertTodo(todo: Todo) {
        require(todo.title.isNotBlank()) { "Title cannot be empty" }
        todoDao.insert(todo.toEntity())
    }

    suspend fun updateTodo(todo: Todo) {
        require(todo.title.isNotBlank()) { "Title cannot be empty" }
        val updatedTodo = todo.copy(updatedAt = Date())
        todoDao.update(updatedTodo.toEntity())
    }

    suspend fun deleteTodoById(id: String) {
        todoDao.deleteById(id)
    }

    suspend fun toggleCompletion(id: String) {
        val todo = todoDao.getTodoById(id) ?: return
        val updated = todo.copy(
            isCompleted = !todo.isCompleted,
            updatedAt = System.currentTimeMillis()
        )
        todoDao.update(updated)
    }
}
