import 'package:camera/camera.dart';
import 'package:ocr_scan_text/ocr_scan/model/recognizer_text/text_block.dart';
import 'package:ocr_scan_text/ocr_scan/model/scan_result.dart';
import 'package:ocr_scan_text/ocr_scan/module/scan_module.dart';
import 'package:ocr_scan_text/ocr_scan/widget/live_scan_widget.dart';
import 'package:vertragshero/pages/img_processing_page/img_processing_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'scan_page_model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ScanPageWidget extends StatefulWidget {
  const ScanPageWidget({super.key, required this.camera});

  static String routeName = 'ScanPage';
  static String routePath = '/scanPage';

  final CameraDescription camera;

  @override
  State<ScanPageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<ScanPageWidget> {
  late ScanPageModel _model;

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScanPageModel());

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color(0xFF2C3E50),
        automaticallyImplyLeading: false,
        title: Text(
          'Scanne einen Vertrag',
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
      body: SafeArea(
          top: true,
          child: Column(
            children: [
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Spacer(),
              RawMaterialButton(
                onPressed: () async {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  final image = await _controller.takePicture();

                  if (!context.mounted) return;

                  context.pushNamed(
                    ImgProcessingWidget.routeName,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.bottomToTop,
                        duration: Duration(milliseconds: 300),
                      ),
                      'imgPath': image.path
                    },
                  );
                },
                elevation: 2.0,
                fillColor: Color(0xFF2C3E50),
                constraints: BoxConstraints(minWidth: 0.0),
                child: Icon(Icons.camera, size: 35.0, color: Colors.white),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
              Spacer()
            ],
          )),
    );
  }
}
