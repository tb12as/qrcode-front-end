import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

const String baseUrl = 'http://47.88.57.201:4000/api';
Future<QR> generateQr(String str) async {
  final response = await http.post(Uri.parse('$baseUrl/qr'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'text': str}));

  if (response.statusCode == 200) {
    return QR.fromJson(jsonDecode(response.body));
  } else {
    // then throw an exception.
    throw Exception('Something is wrong, I can feel it :v');
  }
}

class QR {
  final String base64Str;

  const QR({required this.base64Str});

  factory QR.fromJson(Map<String, dynamic> json) {
    return QR(
      base64Str: json['result'],
    );
  }
}

class GenerateQRComponent extends StatefulWidget {
  const GenerateQRComponent({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<GenerateQRComponent> createState() => _GenerateQRComponentState();
}

class _GenerateQRComponentState extends State<GenerateQRComponent> {
  final _controller = TextEditingController();

  Future<QR>? qrData;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        'QR Code Generator',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        'I made this project for my exercise only, please dont judge me if the ui is so bad :)',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Text to generate',
                        ),
                        minLines: 10,
                        maxLines: 11,
                        autocorrect: false,
                        autofocus: false,
                        controller: _controller,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: (qrData == null)
                            ? const Text('Your qr will be appeare here')
                            : buildQr()),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            qrData = null;
                            qrData = generateQr(_controller.text);
                          });
                        },
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blueGrey,
                            textStyle: const TextStyle(fontSize: 13)),
                        child: const Text(
                          'Generate QR',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  FutureBuilder<QR> buildQr() {
    return FutureBuilder<QR>(
      future: qrData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // remove data:image/png;base64,
          final base64 = snapshot.data!.base64Str.split(',')[1];
          final decodedBytes = base64Decode(base64);

          return Image.memory(decodedBytes);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
