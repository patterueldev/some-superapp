package com.patterueldev.somesuperapp

import android.app.Application
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin
import org.koin.core.logger.Level
import org.koin.ksp.generated.module
import com.patterueldev.somesuperapp.di.AppDIModule

class SomeSuperApp : Application() {
    override fun onCreate() {
        super.onCreate()

        startKoin {
            androidLogger(Level.ERROR)
            androidContext(this@SomeSuperApp)
            modules(
                AppDIModule().module
            )
        }
    }
}
