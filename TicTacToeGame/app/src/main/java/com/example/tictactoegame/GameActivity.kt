package com.example.tictactoegame

import android.content.Intent
import android.os.Binder
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class GameActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.game)

        val playAgainButton = findViewById<Button>(R.id.play_again)
        val goHomeButton = findViewById<Button>(R.id.go_home)
        val turnView = findViewById<TextView>(R.id.turn)
        val player1 = intent.getStringExtra("name1") + "'s turn"
        turnView.text  = player1

        playAgainButton.setOnClickListener {
            //some cool stuff
        }

        goHomeButton.setOnClickListener {
            intent = Intent(this, WelcomeActivity::class.java)
            startActivity(intent)
        }
    }
}