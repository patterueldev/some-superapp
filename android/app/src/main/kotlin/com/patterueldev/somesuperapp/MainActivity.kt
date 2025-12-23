package com.patterueldev.somesuperapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.patterueldev.somesuperapp.data.local.AppDatabase
import com.patterueldev.somesuperapp.data.repository.TodoRepository
import com.patterueldev.somesuperapp.presentation.navigation.AppNavigation
import com.patterueldev.somesuperapp.ui.theme.SomeSuperAppTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize database and repository
        val database = AppDatabase.getInstance(applicationContext)
        val repository = TodoRepository(database.todoDao())
        
        setContent {
            SomeSuperAppTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    AppNavigation(repository = repository)
                }
            }
        }
    }
}

