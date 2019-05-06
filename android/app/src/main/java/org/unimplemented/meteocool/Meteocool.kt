package org.unimplemented.meteocool

import android.support.v7.app.AppCompatActivity
import android.os.Bundle

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.preference.PreferenceManager
import android.util.Log
import android.webkit.WebView

import org.unimplemented.meteocool.security.Validator
import com.google.firebase.iid.FirebaseInstanceId
import org.jetbrains.anko.doAsync
import org.unimplemented.meteocool.location.WebAppInterface
import org.unimplemented.meteocool.onboarding.OnboardingFragment
import org.unimplemented.meteocool.onboarding.Startup
import org.unimplemented.meteocool.utility.JSONClearPost
import org.unimplemented.meteocool.utility.NetworkUtility
import org.unimplemented.meteocool.service.UploadLocationService


class Meteocool : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_meteocool)
        PreferenceManager.getDefaultSharedPreferences(this).apply {
            // Check if we need to display our OnboardingFragment
            if (!getBoolean(OnboardingFragment.IS_ONBOARD_COMPLETED, false)) {
                // The user hasn't seen the OnboardingFragment yet, so show it
                startActivity(Intent(this@Meteocool, Startup::class.java))
            }
        }

        supportFragmentManager.beginTransaction().add(R.id.fragmentContainer, MapFragment()).commit()

        Validator.checkAndroidPermissions(this.applicationContext, this)

        Intent(this, UploadLocationService::class.java).also { intent ->
            startService(intent)
        }

        val preference = PreferenceManager.getDefaultSharedPreferences(applicationContext)
        Log.d("Preferences", preference.getString("FIREBASE_TOKEN", "error"))

        cancelNotifications()

    }

    override fun onStart() {
        super.onStart()
        val mWebView : WebView = findViewById(R.id.webView)
        mWebView.addJavascriptInterface(WebAppInterface(this, mWebView), "Android")
    }

    override fun onResume() {
        super.onResume()
        cancelNotifications()
    }

    private fun cancelNotifications(){
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if(notificationManager.activeNotifications.isNotEmpty()) {
            notificationManager.cancelAll()
            var token = FirebaseInstanceId.getInstance().token
            if (token == null) {
                token = "no token"
            }
            doAsync {
                NetworkUtility.sendClearPostRequest(
                    JSONClearPost(
                        token,
                        "backend"
                    )
                )
            }
        }
    }
}



