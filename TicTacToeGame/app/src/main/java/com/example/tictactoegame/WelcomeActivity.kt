package com.example.tictactoegame

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class WelcomeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.welcome_page)
        val button = findViewById<Button>(R.id.play)
        button.setOnClickListener {
            intent = Intent(this, NamesActivity::class.java)
            startActivity(intent)
        }
    }
}