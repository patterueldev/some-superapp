package com.patterueldev.somesuperapp.data.mapper

import com.patterueldev.somesuperapp.data.local.TodoEntity
import com.patterueldev.somesuperapp.domain.model.Todo
import java.util.Date

fun TodoEntity.toDomain(): Todo {
    return Todo(
        id = id,
        title = title,
        description = description,
        dueDate = dueDate?.let { Date(it) },
        location = location,
        isCompleted = isCompleted,
        createdAt = Date(createdAt),
        updatedAt = Date(updatedAt)
    )
}

fun Todo.toEntity(): TodoEntity {
    return TodoEntity(
        id = id,
        title = title,
        description = description,
        dueDate = dueDate?.time,
        location = location,
        isCompleted = isCompleted,
        createdAt = createdAt.time,
        updatedAt = updatedAt.time
    )
}
