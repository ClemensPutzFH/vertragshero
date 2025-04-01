import 'package:flutter/material.dart';
import 'package:vertragshero/flutter_flow/flutter_flow_theme.dart';

class VertragsCard extends StatelessWidget {
  const VertragsCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.inhalt,
      required this.analyse});

  final String title;
  final String subTitle;
  final String inhalt;
  final String analyse;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  // Add this Expanded widget
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          softWrap: true,
                          maxLines: null, // Allow unlimited lines
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: Text(
                            subTitle,
                            softWrap: true,
                            maxLines: null, // Allow unlimited lines
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: Text(
                            inhalt,
                            softWrap: true,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: Text(
                            'Analyse',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Inter Tight',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Text(
                          analyse,
                          softWrap: true,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
