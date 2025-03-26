import 'package:ocr_scan_text/ocr_scan/model/recognizer_text/text_block.dart';
import 'package:ocr_scan_text/ocr_scan/model/scan_result.dart';
import 'package:ocr_scan_text/ocr_scan/module/scan_module.dart';
import 'package:ocr_scan_text/ocr_scan/widget/live_scan_widget.dart';

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
  const ScanPageWidget({super.key});

  static String routeName = 'ScanPage';
  static String routePath = '/scanPage';

  @override
  State<ScanPageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<ScanPageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
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
      body: SafeArea(top: true, child: _buildLiveScan()),
    );
  }

  Widget _buildLiveScan() {
    return LiveScanWidget(
      ocrTextResult: (ocrTextResult) {
        ocrTextResult.mapResult.forEach((module, result) {});
      },
      scanModules: [ScanAllModule()],
    );
  }
}

class ScanAllModule extends ScanModule {
  @override
  Future<List<ScanResult>> matchedResult(
      List<TextBlock> textBlock, String text) async {
    List<ScanResult> list = [];
    for (var block in textBlock) {
      for (var line in block.lines) {
        for (var element in line.elements) {
          list.add(ScanResult(
              cleanedText: element.text, scannedElementList: [element]));
        }
      }
    }
    return list;
  }
}
