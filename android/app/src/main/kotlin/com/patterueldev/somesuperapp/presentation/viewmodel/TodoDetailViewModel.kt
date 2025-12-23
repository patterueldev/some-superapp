package com.patterueldev.somesuperapp.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.patterueldev.somesuperapp.data.repository.TodoRepository
import com.patterueldev.somesuperapp.domain.model.Todo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class TodoDetailViewModel(private val repository: TodoRepository) : ViewModel() {

    private val _todo = MutableStateFlow<Todo?>(null)
    val todo: StateFlow<Todo?> = _todo.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    fun loadTodo(id: String) {
        viewModelScope.launch {
            try {
                _isLoading.value = true
                _todo.value = repository.getTodoById(id)
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                _isLoading.value = false
            }
        }
    }

    fun updateTodo(todo: Todo) {
        viewModelScope.launch {
            try {
                _isLoading.value = true
                repository.updateTodo(todo)
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                _isLoading.value = false
            }
        }
    }

    fun toggleCompletion(id: String) {
        viewModelScope.launch {
            try {
                repository.toggleCompletion(id)
                _todo.value?.let { current ->
                    _todo.value = current.copy(isCompleted = !current.isCompleted)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun deleteTodo(id: String, onDeleted: () -> Unit) {
        viewModelScope.launch {
            try {
                repository.deleteTodoById(id)
                onDeleted()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
