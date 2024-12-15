package com.example.tictactoegame

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class WelcomeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.welcome_page)

        val button = findViewById<Button>(R.id.play_with_friend)

        intent = Intent(this, NamesActivity::class.java)

        button.setOnClickListener {
            intent = Intent(this, NamesActivity::class.java)
            startActivity(intent)
        }

        findViewById<Button>(R.id.play_with_bot).setOnClickListener {
            intent = Intent(this, BotActivity::class.java)
            intent.putExtra("name1", "Human")
            intent.putExtra("name2", "Bot")
            startActivity(intent)
        }
    }
}