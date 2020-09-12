import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:chatbot/msg_bubble.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();
  final List<Map> messages = List();

  void chatbotResponse(query) async {
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson:
                'assets/friend-dialogflow.json') // todo: add your json key to assets and replace this string with that file name
        .build(); // returns scopes, session id, project id, access token
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);

    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messages.insert(0, {
        'isUser': false,
        'message': aiResponse.getMessage() ??
            TypeMessage(aiResponse.getListMessage()[0]).platform
      });
    });

    print(aiResponse.getListMessage()[0]['text']['text'][0].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chatbot",
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.blue,
              Colors.indigo,
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => MessageBubble(
                    messages[index]['message'].toString(),
                    messages[index]['isUser']),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.lightBlueAccent,
            ),
            ListTile(
              title: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromRGBO(220, 220, 220, 1),
                ),
                padding: EdgeInsets.only(left: 15),
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Type a Message',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.send,
                  size: 30.0,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () {
                  if (textController.text.isEmpty) {
                    print('empty message'); // do nothing
                  } else {
                    setState(() {
                      // add user's message to the beginning of messages list
                      messages.insert(
                          0, {'isUser': true, 'message': textController.text});
                    });

                    // invoke Dialogflow
                    chatbotResponse(textController.text);
                    textController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
