package com.patterueldev.somesuperapp.di

import android.content.Context
import com.patterueldev.somesuperapp.data.local.AppDatabase
import com.patterueldev.somesuperapp.data.local.TodoDao
import org.koin.core.annotation.ComponentScan
import org.koin.core.annotation.Module
import org.koin.core.annotation.Single

@Module
@ComponentScan("com.patterueldev.somesuperapp")
class AppDIModule {
    @Single
    fun provideDatabase(context: Context): AppDatabase = AppDatabase.getInstance(context)

    @Single
    fun provideTodoDao(db: AppDatabase): TodoDao = db.todoDao()
}
