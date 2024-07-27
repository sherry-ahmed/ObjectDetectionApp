import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 79, 172, 56),
        foregroundColor: Colors.white,
      )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final serverIpAddress =
      "0.0.0.0"; // Replace with your Python server's IP address
  final picker = ImagePicker();
  File? _imageFile;
  String _output = "";

  Future<void> _selectAndSendImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _output = "Sending image...";
      });

      // Send image to Python server
      await _sendImageToServer(_imageFile!);
    }
  }

  Future<void> _sendImageToServer(File imageFile) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://$serverIpAddress:5000/classify_image'));
      request.files.add(http.MultipartFile(
          'image', imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
          filename: 'image.jpg'));

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = json.decode(utf8.decode(responseData));

      setState(() {
        _output = "Result: $result";
      });

      print("Result from Python server: $result");
    } catch (e) {
      setState(() {
        _output = "Error Uploading Image! ";
      });
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant AI'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Container(
                    width: 270,
                    height: 480,
                    child: Card(
                      elevation: 10, // Adjust elevation as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            40), // Adjust the radius as needed
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            40), // Same radius as the Card's shape
                        child: Padding(
                          padding: const EdgeInsets.all(
                              0.0), // Adjust the padding as needed
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                : const Text('No image selected'),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _selectAndSendImage(ImageSource.gallery),
                  child: const Text('Select from Gallery'),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(fontSize: 15)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _selectAndSendImage(ImageSource.camera),
                  child: const Text('Capture from Camera'),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(fontSize: 15)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Result: $_output"
                  ,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
