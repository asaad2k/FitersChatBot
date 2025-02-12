import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class CerateChatsModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textController?.dispose();
  }

  /// Additional helper methods are added here.

}
