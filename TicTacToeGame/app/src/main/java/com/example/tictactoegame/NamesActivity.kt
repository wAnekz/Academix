package com.example.tictactoegame

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class NamesActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.names)
        val submitButton = findViewById<Button>(R.id.submit_names)
        val player1 = findViewById<EditText>(R.id.player_1)
        val player2 = findViewById<EditText>(R.id.player_2)

        submitButton.setOnClickListener {
            val name1 = player1.text.toString().trim()
            val name2 = player2.text.toString().trim()
            if (name1 == "" || name2 == "") {
                println("pizdets")
                Toast.makeText(this, "You have empty fields", Toast.LENGTH_LONG).show()
            }
            else {
                val intent = Intent(this, GameActivity::class.java)
                intent.putExtra("name1", name1)
                intent.putExtra("name2", name2)
                startActivity(intent)
            }
        }
    }
}