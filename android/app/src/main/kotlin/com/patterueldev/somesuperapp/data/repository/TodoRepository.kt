package com.patterueldev.somesuperapp.data.repository

import com.patterueldev.somesuperapp.data.local.TodoDao
import com.patterueldev.somesuperapp.data.mapper.toDomain
import com.patterueldev.somesuperapp.data.mapper.toEntity
import com.patterueldev.somesuperapp.domain.model.Todo
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.util.Date
import org.koin.core.annotation.Single

// Contract
interface TodoRepository {
    fun getAllTodos(): Flow<List<Todo>>
    suspend fun getTodoById(id: String): Todo?
    suspend fun insertTodo(todo: Todo)
    suspend fun updateTodo(todo: Todo)
    suspend fun deleteTodoById(id: String)
    suspend fun toggleCompletion(id: String)
}

// Implementation
@Single(binds = [TodoRepository::class])
class TodoRepositoryImpl(private val todoDao: TodoDao) : TodoRepository {

    override fun getAllTodos(): Flow<List<Todo>> {
        return todoDao.getAllTodos().map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override suspend fun getTodoById(id: String): Todo? {
        return todoDao.getTodoById(id)?.toDomain()
    }

    override suspend fun insertTodo(todo: Todo) {
        require(todo.title.isNotBlank()) { "Title cannot be empty" }
        todoDao.insert(todo.toEntity())
    }

    override suspend fun updateTodo(todo: Todo) {
        require(todo.title.isNotBlank()) { "Title cannot be empty" }
        val updatedTodo = todo.copy(updatedAt = Date())
        todoDao.update(updatedTodo.toEntity())
    }

    override suspend fun deleteTodoById(id: String) {
        todoDao.deleteById(id)
    }

    override suspend fun toggleCompletion(id: String) {
        val todo = todoDao.getTodoById(id) ?: return
        val updated = todo.copy(
            isCompleted = !todo.isCompleted,
            updatedAt = System.currentTimeMillis()
        )
        todoDao.update(updated)
    }
}
