package com.patterueldev.somesuperapp.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.patterueldev.somesuperapp.data.repository.TodoRepository
import com.patterueldev.somesuperapp.domain.model.Todo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import org.koin.android.annotation.KoinViewModel

// all viewmodels should follow this implementation
abstract class TodoDetailViewModel : ViewModel() {
    abstract val todo: StateFlow<Todo?>
    abstract val isLoading: StateFlow<Boolean>

    abstract fun loadTodo(id: String)
    abstract fun updateTodo(todo: Todo)
    abstract fun toggleCompletion(id: String)
    abstract fun deleteTodo(id: String, onDeleted: () -> Unit)
}

@KoinViewModel(binds = [TodoDetailViewModel::class])
class TodoDetailViewModelImpl(private val repository: TodoRepository) : TodoDetailViewModel() {

    private val _todo = MutableStateFlow<Todo?>(null)
    override val todo: StateFlow<Todo?> = _todo.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    override val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    override fun loadTodo(id: String) {
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

    override fun updateTodo(todo: Todo) {
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

    override fun toggleCompletion(id: String) {
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

    override fun deleteTodo(id: String, onDeleted: () -> Unit) {
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
