import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/constants.dart';

class AssistanceScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'What is this app about?',
      'answer': 'This app helps users set financial goals, save liquid cash, and earn rewards for saving.'
    },
    {
      'question': 'How do I create a financial goal?',
      'answer': 'To create a financial goal, go to the "Goals" section and follow the instructions to add a new goal.'
    },
    {
      'question': 'Can I save unlimited cash?',
      'answer': 'Yes, you can save any amount of liquid cash without any upper limit.'
    },
    {
      'question': 'How do I earn rewards?',
      'answer': 'You earn rewards by saving money and building good financial habits. The app generates rewards automatically.'
    },
    {
      'question': 'Is goal setting mandatory for savings?',
      'answer': 'Yes, you must first add financial goals to start saving money. This ensures a purpose-driven saving habit.'
    },
    {
      'question': 'How can I withdraw my savings?',
      'answer': 'You can withdraw your savings at any time without any holding period. The withdrawn amounts are deposited into your bank account within 10 minutes.'
    },
    {
      'question': 'Are there low-cost products available?',
      'answer': 'Yes, the app offers a variety of products at low costs for users to purchase.'
    },
    {
      'question': 'Can I bargain for prices?',
      'answer': 'Yes, you can negotiate prices when buying new products. This unique feature is not available in other e-commerce apps.'
    },
    {
      'question': 'Can I access other e-commerce platforms through this app?',
      'answer': 'Yes, you can access Flipkart, Amazon, Ajio, and Myntra through the app. Purchases made via these platforms through the app earn you commission rewards.'
    },
    {
      'question': 'What are the referral rewards?',
      'answer': 'You can earn ₹100 for every successful referral login, incentivizing you to share the app with others.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Our App!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Here are some frequently asked questions:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              ...faqs.map((faq) => FAQCard(question: faq['question']!, answer: faq['answer']!)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  final String question;
  final String answer;

  const FAQCard({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}