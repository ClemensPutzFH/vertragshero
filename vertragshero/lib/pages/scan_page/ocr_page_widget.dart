import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:rive/rive.dart';
import 'package:vertragshero/flutter_flow/flutter_flow_rive_controller.dart';
import 'package:vertragshero/flutter_flow/flutter_flow_theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vertragshero/widgets/vertrag.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key, required this.source});

  final String source;

  static String routeName = 'OcrPage';
  static String routePath = '/ocrPage';

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  bool _isLoading = false;
  XFile? _imageFile;
  String _recognizedText = 'No text recognized yet';
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  RiveAnimationController? _controller;

  String responseTitleText = "";
  String responseSubTitleText = "";
  String responseInterpretationText = "";
  String responseInhaltText = "";

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.source == "camera") {
      _pickImage(ImageSource.camera);
    }

    if (widget.source == "gallery") {
      _pickImage(ImageSource.gallery);
    }
    super.initState();
  }

  // Method to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final XFile? selected = await _picker.pickImage(source: source);

    if (selected != null) {
      setState(() {
        _imageFile = selected;
        _recognizedText = 'Analyzing image...';
        _isLoading = true;
        _controller = SimpleAnimation('Flip Up');
      });

      // Process the image for OCR
      _extractText();
    }
  }

  // Method to perform OCR on the selected image
  Future<void> _extractText() async {
    print("extract");
    if (_imageFile == null) return;
    print("extract into");

    // Create an InputImage object from the XFile
    final inputImage = InputImage.fromFilePath(_imageFile!.path);

    try {
      print("try");
      // Process the input image
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);
      print("text");
      // Extract the text
      String extractedText = recognizedText.text;

      final openAIService = OpenAIService(
          apiKey:
              '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');
      print("openApi");
      responseTitleText = await openAIService.getChatResponse(
          "Gibt mir bitte einen kurzen Titel zu dem text. Es handelt sich um einen juristischen Kontext. Nur den Titel bitte (maximal 5 Wörter): " +
              extractedText);

      responseSubTitleText = await openAIService.getChatResponse(
          "Gibt mir bitte einen kurzen Sub-Titel zu dem text. Es handelt sich um einen juristischen Kontext. Nur den Sub-Titel bitte(maximal 8 Wörter): " +
              extractedText);

      responseInhaltText = await openAIService.getChatResponse(
          "Gibt mir bitte eine ganz kurze Zusammenfassung!: " + extractedText);

      responseInterpretationText = await openAIService.getChatResponse(
          "Dieser text sollte ein Vertrag sein. Bitte gib mir ausschließlich Informationen über die Formalität des vertrages! Würde so ein Vertrag vorm Gericht stand halten? Wurde der vertrag korrekt formuliert? ist es überhaupt ein Vertrag? Ist er richtig formuliert?  Bitte kurz und prägnant: " +
              extractedText);

      print("response");
      print("recognized: " + extractedText);
      print("gpt: " + responseTitleText);

      setState(() {
        print("state");
        _recognizedText = extractedText.isEmpty
            ? 'No text found in the image'
            : extractedText;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _recognizedText = 'Error recognizing text: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2C3E50),
        title: Text(
          'Vertrag wird analysiert',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Inter Tight',
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
              ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2.0,
      ),
      body: !_isLoading
          ? VertragsCard(
              title: responseTitleText,
              subTitle: responseSubTitleText,
              inhalt: responseInhaltText,
              analyse: responseInterpretationText)
          : Center(
              child: _controller == null
                  ? CircularProgressIndicator(
                      color: Color(0xFF2C3E50),
                    )
                  : RiveAnimation.asset(
                      'assets/rive_animations/ocr_card.riv',
                      artboard: 'Artboard',
                      fit: BoxFit.contain,
                      controllers: [_controller!],
                    ),
            ),
      /*SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Image preview
            if (_imageFile != null)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Image.file(
                  File(_imageFile!.path),
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            // Loading indicator
            if (_isLoading) const CircularProgressIndicator(),

            const SizedBox(height: 20),

            // Recognized text display
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _recognizedText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),*/ /*
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Camera button
          FloatingActionButton(
            onPressed: () => _pickImage(ImageSource.camera),
            heroTag: 'camera',
            tooltip: 'Take a photo',
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 16),

          // Gallery button
          FloatingActionButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            heroTag: 'gallery',
            tooltip: 'Pick from gallery',
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),*/
    );
  }
}

class OpenAIService {
  final String apiKey;
  final String baseUrl = 'https://api.openai.com/v1/chat/completions';

  OpenAIService({required this.apiKey});

  Future<String> getChatResponse(String prompt) async {
    print("post");
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.7
      }),
    );
    print("after await");

    if (response.statusCode == 200) {
      print("Code 200");
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      print("exception" + response.body);
      throw Exception('Failed to get response: ${response.body}');
    }
  }
}
