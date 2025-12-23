package com.patterueldev.somesuperapp.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.patterueldev.somesuperapp.data.repository.TodoRepository
import com.patterueldev.somesuperapp.domain.model.Todo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import org.koin.android.annotation.KoinViewModel

// Base contract
abstract class TodoListViewModel : ViewModel() {
    abstract val todos: StateFlow<List<Todo>>
    abstract val isLoading: StateFlow<Boolean>

    abstract fun addTodo(todo: Todo)
    abstract fun toggleCompletion(id: String)
    abstract fun deleteTodo(id: String)
}

@KoinViewModel(binds = [TodoListViewModel::class])
class TodoListViewModelImpl(private val repository: TodoRepository) : TodoListViewModel() {

    override val todos: StateFlow<List<Todo>> = repository.getAllTodos()
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    private val _isLoading = MutableStateFlow(false)
    override val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    override fun addTodo(todo: Todo) {
        viewModelScope.launch {
            try {
                _isLoading.value = true
                repository.insertTodo(todo)
            } catch (e: Exception) {
                // Handle error (e.g., show snackbar)
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
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    override fun deleteTodo(id: String) {
        viewModelScope.launch {
            try {
                repository.deleteTodoById(id)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
