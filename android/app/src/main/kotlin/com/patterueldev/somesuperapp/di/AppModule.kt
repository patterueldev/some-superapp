package com.patterueldev.somesuperapp.di

import com.patterueldev.somesuperapp.data.local.AppDatabase
import com.patterueldev.somesuperapp.data.repository.TodoRepository
import com.patterueldev.somesuperapp.presentation.viewmodel.TodoDetailViewModel
import com.patterueldev.somesuperapp.presentation.viewmodel.TodoListViewModel
import org.koin.android.ext.koin.androidContext
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.dsl.module

val appModule = module {
    // Database
    single { AppDatabase.getInstance(androidContext()) }

    // DAOs
    single { get<AppDatabase>().todoDao() }

    // Repositories
    single { TodoRepository(get()) }

    // ViewModels
    viewModel { TodoListViewModel(get()) }
    viewModel { TodoDetailViewModel(get()) }
}

