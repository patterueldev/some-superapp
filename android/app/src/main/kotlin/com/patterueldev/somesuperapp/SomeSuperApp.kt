package com.patterueldev.somesuperapp

import android.app.Application
import com.patterueldev.somesuperapp.di.appModule
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin
import org.koin.core.logger.Level

class SomeSuperApp : Application() {
    override fun onCreate() {
        super.onCreate()

        startKoin {
            // Log Koin into Android logger
            androidLogger(Level.ERROR)
            // Reference Android context
            androidContext(this@SomeSuperApp)
            // Load modules
            modules(appModule)
        }
    }
}

