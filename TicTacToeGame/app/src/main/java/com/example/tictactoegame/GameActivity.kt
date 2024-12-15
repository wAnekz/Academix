package com.example.tictactoegame

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.example.tictactoegame.databinding.GameBinding

class GameActivity : AppCompatActivity() {
    enum class Turn {
        NOUGHT,
        CROSS
    }

    val handler = Handler(Looper.getMainLooper())

    private var firstTurn = Turn.CROSS
    private var currentTurn = Turn.CROSS

    private var crossesScore = 0
    private var noughtsScore = 0

    private var boardList = mutableListOf<Button>()

    private lateinit var binding: GameBinding
    @SuppressLint("SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = GameBinding.inflate(layoutInflater)
        setContentView(binding.root)
        initBoard()

        val goHomeButton = findViewById<Button>(R.id.go_home)
        binding.turn.text = intent.getStringExtra("name1") + "'s turn"

        goHomeButton.setOnClickListener {
            intent = Intent(this, WelcomeActivity::class.java)
            startActivity(intent)
        }
    }

    private fun initBoard() {
        boardList.add(binding.a1)
        boardList.add(binding.a2)
        boardList.add(binding.a3)
        boardList.add(binding.b1)
        boardList.add(binding.b2)
        boardList.add(binding.b3)
        boardList.add(binding.c1)
        boardList.add(binding.c2)
        boardList.add(binding.c3)

    }

    fun boardTapped(view: View) {
        if(view !is Button) {
            return
        }
        addToBoard(view)

        if (checkForVictory(NOUGHT)) {
            noughtsScore++
            result( intent.getStringExtra("name1") + " won!")
        }

        if (checkForVictory(CROSS)) {
            crossesScore++
            result( intent.getStringExtra("name2") + " won!")
        }

        if (fullBoard()) {
            result("Draw")
        }
    }

    private fun checkForVictory(s: String): Boolean {
        //Horizontal victory

        if (match(binding.a1, s) && match(binding.a2, s) && match(binding.a3, s)) {
            binding.a1.setBackgroundColor(getColor(R.color.green))
            binding.a2.setBackgroundColor(getColor(R.color.green))
            binding.a3.setBackgroundColor(getColor(R.color.green))
            return true
        }

        if (match(binding.b1, s) && match(binding.b2, s) && match(binding.b3, s)){
            binding.b1.setBackgroundColor(getColor(R.color.green))
            binding.b2.setBackgroundColor(getColor(R.color.green))
            binding.b3.setBackgroundColor(getColor(R.color.green))
            return true
        }

        if (match(binding.c1, s) && match(binding.c2, s) && match(binding.c3, s)){
            binding.c1.setBackgroundColor(getColor(R.color.green))
            binding.c2.setBackgroundColor(getColor(R.color.green))
            binding.c3.setBackgroundColor(getColor(R.color.green))
            return true
        }

        //vertical victory

        if (match(binding.a1, s) && match(binding.b1, s) && match(binding.c1, s)) {
            binding.a1.setBackgroundColor(getColor(R.color.green))
            binding.b1.setBackgroundColor(getColor(R.color.green))
            binding.c1.setBackgroundColor(getColor(R.color.green))
            return true
        }

        if (match(binding.a2, s) && match(binding.b2, s) && match(binding.c2, s)){
            binding.a2.setBackgroundColor(getColor(R.color.green))
            binding.b2.setBackgroundColor(getColor(R.color.green))
            binding.c2.setBackgroundColor(getColor(R.color.green))
            return true
        }

        if (match(binding.a3, s) && match(binding.b3, s) && match(binding.c3, s)){
            binding.a3.setBackgroundColor(getColor(R.color.green))
            binding.b3.setBackgroundColor(getColor(R.color.green))
            binding.c3.setBackgroundColor(getColor(R.color.green))
            return true
        }

        //diagonal victory

        if (match(binding.a1, s) && match(binding.b2, s) && match(binding.c3, s)){
            binding.a1.setBackgroundColor(getColor(R.color.green))
            binding.b2.setBackgroundColor(getColor(R.color.green))
            binding.c3.setBackgroundColor(getColor(R.color.green))
            return true
        }

        if (match(binding.a3, s) && match(binding.b2, s) && match(binding.c1, s)){
            binding.a3.setBackgroundColor(getColor(R.color.green))
            binding.b2.setBackgroundColor(getColor(R.color.green))
            binding.c1.setBackgroundColor(getColor(R.color.green))
            return true
        }

        return false
    }

    private fun match (button: Button, symbol: String): Boolean = button.text == symbol

    private fun result(title: String) {
        val message = "\n ${intent.getStringExtra("name1") + "'s score:"} $noughtsScore\n\n ${intent.getStringExtra("name2") + "'s score:"} $crossesScore"
        handler.postDelayed({
            AlertDialog.Builder(this)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton("Again") { _, _ ->
                    resetBoard()
                }
                .setNegativeButton("Go home") { _, _ ->
                    intent = Intent(this, WelcomeActivity::class.java)
                    startActivity(intent)
                }
                .setCancelable(false)
                .show()
        }, 1000)
    }

    @SuppressLint("SetTextI18n")
    private fun resetBoard() {
        for (button in boardList) {
            button.text = ""
            button.background = null
        }
        if (firstTurn == Turn.NOUGHT) {
            firstTurn = Turn.CROSS
        } else if (firstTurn == Turn.CROSS) {
            firstTurn = Turn.NOUGHT
        }
        currentTurn = firstTurn
        setTurnLabel(binding.turn)
        }

    private fun fullBoard(): Boolean {
        for (button in boardList) {
            if (button.text == "") {
                return false
            }
        }
        return true
    }

    private fun addToBoard(button: Button) {
        if (button.text != "") {
            return
        }
        if (currentTurn == Turn.NOUGHT) {
            button.text = NOUGHT
            button.setTextColor(getColor(R.color.color_nought))
            currentTurn = Turn.CROSS
        } else if (currentTurn == Turn.CROSS) {
            button.text = CROSS
            button.setTextColor(getColor(R.color.color_cross))
            currentTurn = Turn.NOUGHT
        }
        setTurnLabel(binding.turn)
    }

    @SuppressLint("SetTextI18n")
    private fun setTurnLabel(turnView: TextView) {
        val turnText = when (currentTurn) {
            Turn.CROSS -> "Turn: $CROSS"
            Turn.NOUGHT -> "Turn: $NOUGHT"
        }
        if (turnText == "Turn: $CROSS") {
            turnView.text = intent.getStringExtra("name1") + "'s turn"
        } else {
            turnView.text = intent.getStringExtra("name2") + "'s turn"
        }
    }

    companion object{
        const val NOUGHT = "0"
        const val CROSS = "X"
    }
}