package com.patterueldev.somesuperapp.domain.model

import java.util.Date
import java.util.UUID

data class Todo(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val description: String? = null,
    val dueDate: Date? = null,
    val location: String? = null,
    val isCompleted: Boolean = false,
    val createdAt: Date = Date(),
    val updatedAt: Date = Date()
)
