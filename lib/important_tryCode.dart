
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GroceryInputScreen(),
      debugShowCheckedModeBanner: false,
    );
  }





}

class GroceryInputScreen extends StatefulWidget {
  @override
  State<GroceryInputScreen> createState() => _GroceryInputScreenState();
}

class _GroceryInputScreenState extends State<GroceryInputScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _loading = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('Status: $val'),
        onError: (val) => print('Error: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'en_IN',
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _sendToGPT() async {
    setState(() => _loading = true);
    try {
      final result = await getGroceryJsonFromGPT(_controller.text);
      print(result);
      setState(() => _response = result);
    } catch (e) {
      setState(() => _response = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grocery Parser')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Enter order in Thanglish',
              hintText: 'eg: rendu liter milk, oru kg arisi',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendToGPT,
                  child: _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Convert to JSON'),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                onPressed: _listen,
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('Response:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(_response),
            ),
          ),

          ElevatedButton(onPressed: () async {await exportFirestoreCollectionToJson("AreaMeatPrices");
    }, child: Text("data"))
        ]),
      ),
    );
  }

  Future<void> exportFirestoreCollectionToJson(String collectionName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection(collectionName).get();

      final List<Map<String, dynamic>> jsonData = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data()
        };
      }).toList();

      final String jsonString = jsonEncode(jsonData);
      print(jsonString); // You can also save this string to a file if needed.
    } catch (e) {
      print('Error exporting Firestore data: $e');
    }
  }

  Future<String> getGroceryJsonFromGPT(String userInput) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
          "You are a helpful assistant who understands Thanglish (Tamil in English letters). Extract grocery items and their quantities and return only in a clean JSON array format like: [{\"item\": \"milk\", \"quantity\": \"2 liters\"}]."
        },
        {
          "role": "user",
          "content": userInput
        }
      ],
      "temperature": 0.2
    };

    final response =
    await http.post(uri, headers: headers, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final content = jsonResponse['choices'][0]['message']['content'];
      return content;
    } else {
      throw Exception('Failed to get response: ${response.body}');
    }
  }
}
