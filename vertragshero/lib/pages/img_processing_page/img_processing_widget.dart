import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ocr_scan_text/ocr_scan/model/recognizer_text/text_block.dart';
import 'package:ocr_scan_text/ocr_scan/model/scan_result.dart';
import 'package:ocr_scan_text/ocr_scan/module/scan_module.dart';
import 'package:ocr_scan_text/ocr_scan/widget/live_scan_widget.dart';
import 'package:ocr_scan_text/ocr_scan/widget/static_scan_widget.dart';
import 'package:vertragshero/pages/img_processing_page/img_processing_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'img_processing_model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ImgProcessingWidget extends StatefulWidget {
  const ImgProcessingWidget({super.key, required this.imgPath});

  static String routeName = 'ImgProcPage';
  static String routePath = '/imgProcPage';

  final String imgPath;

  @override
  State<ImgProcessingWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<ImgProcessingWidget> {
  late ImgProcessingModel _model;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ImgProcessingModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaticScanWidget(
          ocrTextResult: (ocrTextResult) {},
          scanModules: [ScanAllModule()],
          file: File(widget.imgPath)),
    );
  }
}

class ScanAllModule extends ScanModule {
  ScanAllModule()
      : super(
            label: 'All',
            color: Colors.redAccent.withOpacity(0.3),
            validateCountCorrelation: 1);

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
