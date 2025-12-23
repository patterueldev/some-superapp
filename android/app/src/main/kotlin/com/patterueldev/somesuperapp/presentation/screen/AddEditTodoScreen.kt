package com.patterueldev.somesuperapp.presentation.screen

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.patterueldev.somesuperapp.domain.model.Todo
import java.text.SimpleDateFormat
import java.util.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddEditTodoScreen(
    existingTodo: Todo?,
    onNavigateBack: () -> Unit,
    onSave: (Todo) -> Unit
) {
    var title by remember { mutableStateOf(existingTodo?.title ?: "") }
    var description by remember { mutableStateOf(existingTodo?.description ?: "") }
    var targetDate by remember { mutableStateOf<Date?>(existingTodo?.dueDate) }
    var location by remember { mutableStateOf(existingTodo?.location ?: "") }
    var titleError by remember { mutableStateOf(false) }
    var showDatePicker by remember { mutableStateOf(false) }
    var showTimePicker by remember { mutableStateOf(false) }

    val isEditing = existingTodo != null

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(if (isEditing) "Edit Todo" else "Add Todo") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Default.Close, contentDescription = "Cancel")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            OutlinedTextField(
                value = title,
                onValueChange = {
                    title = it
                    titleError = it.isBlank()
                },
                label = { Text("Title *") },
                modifier = Modifier.fillMaxWidth(),
                isError = titleError,
                supportingText = if (titleError) {
                    { Text("Title is required") }
                } else null,
                singleLine = true
            )

            OutlinedTextField(
                value = description,
                onValueChange = { description = it },
                label = { Text("Description") },
                modifier = Modifier.fillMaxWidth(),
                minLines = 3,
                maxLines = 5
            )

            OutlinedTextField(
                value = targetDate?.let {
                    SimpleDateFormat("MMM dd, yyyy • hh:mm a", Locale.getDefault()).format(it)
                } ?: "",
                onValueChange = { },
                label = { Text("Target Date") },
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { showDatePicker = true },
                enabled = false,
                trailingIcon = {
                    if (targetDate != null) {
                        IconButton(onClick = { targetDate = null }) {
                            Icon(Icons.Default.Close, contentDescription = "Clear date")
                        }
                    }
                },
                colors = OutlinedTextFieldDefaults.colors(
                    disabledTextColor = MaterialTheme.colorScheme.onSurface,
                    disabledBorderColor = MaterialTheme.colorScheme.outline,
                    disabledLeadingIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                    disabledTrailingIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                    disabledLabelColor = MaterialTheme.colorScheme.onSurfaceVariant,
                    disabledPlaceholderColor = MaterialTheme.colorScheme.onSurfaceVariant
                )
            )

            OutlinedTextField(
                value = location,
                onValueChange = { location = it },
                label = { Text("Location") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            Spacer(modifier = Modifier.weight(1f))

            Button(
                onClick = {
                    if (title.isBlank()) {
                        titleError = true
                        return@Button
                    }

                    val todo = if (isEditing) {
                        existingTodo!!.copy(
                            title = title,
                            description = description.ifBlank { null },
                            dueDate = targetDate,
                            location = location.ifBlank { null }
                        )
                    } else {
                        Todo(
                            title = title,
                            description = description.ifBlank { null },
                            dueDate = targetDate,
                            location = location.ifBlank { null }
                        )
                    }
                    onSave(todo)
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(if (isEditing) "Save Changes" else "Add Todo")
            }
        }
    }

    // Date picker dialog
    if (showDatePicker) {
        DatePickerDialog(
            onDismiss = { showDatePicker = false },
            onConfirm = { selectedDateMillis ->
                if (selectedDateMillis != null) {
                    val calendar = Calendar.getInstance().apply {
                        timeInMillis = selectedDateMillis
                    }
                    if (targetDate != null) {
                        val currentCalendar = Calendar.getInstance().apply {
                            time = targetDate
                        }
                        // Preserve time from current target date
                        calendar.set(Calendar.HOUR_OF_DAY, currentCalendar.get(Calendar.HOUR_OF_DAY))
                        calendar.set(Calendar.MINUTE, currentCalendar.get(Calendar.MINUTE))
                    } else {
                        // Default to 9:00 AM if no time set
                        calendar.set(Calendar.HOUR_OF_DAY, 9)
                        calendar.set(Calendar.MINUTE, 0)
                    }
                    targetDate = calendar.time
                    showDatePicker = false
                    showTimePicker = true
                }
            },
            initialSelectedDateMillis = targetDate?.time
        )
    }

    // Time picker dialog
    if (showTimePicker) {
        TimePickerDialog(
            onDismiss = { showTimePicker = false },
            onConfirm = { hour, minute ->
                val calendar = Calendar.getInstance().apply {
                    time = targetDate ?: Date()
                    set(Calendar.HOUR_OF_DAY, hour)
                    set(Calendar.MINUTE, minute)
                }
                targetDate = calendar.time
                showTimePicker = false
            },
            initialHour = if (targetDate != null) {
                Calendar.getInstance().apply { time = targetDate }.get(Calendar.HOUR_OF_DAY)
            } else {
                9
            },
            initialMinute = if (targetDate != null) {
                Calendar.getInstance().apply { time = targetDate }.get(Calendar.MINUTE)
            } else {
                0
            }
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun DatePickerDialog(
    onDismiss: () -> Unit,
    onConfirm: (Long?) -> Unit,
    initialSelectedDateMillis: Long? = null
) {
    val datePickerState = rememberDatePickerState(initialSelectedDateMillis = initialSelectedDateMillis)

    androidx.compose.material3.DatePickerDialog(
        onDismissRequest = onDismiss,
        confirmButton = {
            TextButton(onClick = { onConfirm(datePickerState.selectedDateMillis) }) {
                Text("OK")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    ) {
        DatePicker(state = datePickerState)
    }
}

@Composable
private fun TimePickerDialog(
    onDismiss: () -> Unit,
    onConfirm: (hour: Int, minute: Int) -> Unit,
    initialHour: Int = 9,
    initialMinute: Int = 0
) {
    var hour by remember { mutableStateOf(initialHour) }
    var minute by remember { mutableStateOf(initialMinute) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Select Time") },
        text = {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(16.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Hour", style = MaterialTheme.typography.labelSmall)
                        OutlinedTextField(
                            value = hour.toString().padStart(2, '0'),
                            onValueChange = { value ->
                                hour = value.toIntOrNull()?.coerceIn(0, 23) ?: hour
                            },
                            modifier = Modifier.width(80.dp),
                            textStyle = MaterialTheme.typography.headlineMedium,
                            singleLine = true
                        )
                    }
                    Text(":", style = MaterialTheme.typography.headlineMedium)
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Min", style = MaterialTheme.typography.labelSmall)
                        OutlinedTextField(
                            value = minute.toString().padStart(2, '0'),
                            onValueChange = { value ->
                                minute = value.toIntOrNull()?.coerceIn(0, 59) ?: minute
                            },
                            modifier = Modifier.width(80.dp),
                            textStyle = MaterialTheme.typography.headlineMedium,
                            singleLine = true
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = { onConfirm(hour, minute) }) {
                Text("OK")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}
