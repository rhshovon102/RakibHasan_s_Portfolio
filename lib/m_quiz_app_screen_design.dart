import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rakibhasan/m_quiz_app_main.dart';
import 'package:rakibhasan/m_quiz_app_end.dart';
import 'package:rakibhasan/m_quiz_app_question_answer_conditions.dart';
import 'package:rakibhasan/m_quiz_app_calculator.dart';
import 'dart:async';

class screen_design extends StatefulWidget {
  const screen_design({Key? key});

  @override
  State<screen_design> createState() => _screen_designState();
}

class _screen_designState extends State<screen_design> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int timeLeft = 60; // Initialize the timer with 60 seconds
  late Timer _timer; // Declare a timer

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the countdown timer when the widget is initialized
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        goToNextQuestion(); // Automatically go to the next question when time is up
      }
    });
  }

  void picAnswer(int value) {
    setState(() {
      selectedAnswerIndex = value;
      final question = getQuestionList('$question_type')[questionIndex];

      if (selectedAnswerIndex == question.correctAnswerIndex) {
        count++;
      }
    });
  }

  void goToNextQuestion() {
    setState(() {
      if (questionIndex < getQuestionList('$question_type').length - 1) {
        questionIndex++; // Move to the next question
        timeLeft = 60; // Reset the timer to 60 seconds
        selectedAnswerIndex = null; // Clear the selected answer
        startTimer(); // Start the timer for the next question
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = getQuestionList('$question_type')[questionIndex];
    bool isLastQuestion = questionIndex == getQuestionList('$question_type').length - 1;

    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey4,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      child: Text(
                        "Time Left: " + timeLeft.toString(),
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      child: Text(
                        question.question,
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: selectedAnswerIndex == null ? () => picAnswer(index) : null,
                      child: AnswerCard(
                        currentIndex: index,
                        question: question.options[index],
                        isSelected: selectedAnswerIndex == index,
                        selectedAnswerIndex: selectedAnswerIndex,
                        correctAnswerIndex: question.correctAnswerIndex,
                      ),
                    );
                  },
                ),
                Expanded(child: SizedBox()),
                isLastQuestion
                    ? button(
                  onpressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => end()),
                      );
                    });
                  },
                  label: 'Finish',
                )
                    : button(
                  onpressed: selectedAnswerIndex != null ? goToNextQuestion : null,
                  label: 'Next',
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(CupertinoColors.systemYellow),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => calculator()),
                        );
                      },
                      child: Text("Use Calculator", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}