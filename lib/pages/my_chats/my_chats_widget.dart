import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
//import 'package:dart_openai/openai.dart';
import 'package:smartai/auth/firebase_firestore/firestore_constatnts.dart';
import 'package:smartai/auth/firebase_firestore/firestore_util.dart';
import '../../auth/firebase_firestore/thread_model.dart';
import '../new_chats/new_chats_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/cerate_chats/cerate_chats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'my_chats_model.dart';
export 'my_chats_model.dart';

class MyChatsWidget extends StatefulWidget {
  const MyChatsWidget({
    Key? key,
    this.createchat,
  }) : super(key: key);

  final String? createchat;

  @override
  _MyChatsWidgetState createState() => _MyChatsWidgetState();
}

class _MyChatsWidgetState extends State<MyChatsWidget>
    with TickerProviderStateMixin {
  late MyChatsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0.0, 70.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyChatsModel());

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => setState(() {}));

    
  }

  

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CerateChatsWidget(
                createchat: widget.createchat,
              ),
            ),
          );
        },
        backgroundColor: FlutterFlowTheme.of(context).primary,
        elevation: 8.0,
        child: Icon(
          Icons.add_rounded,
          color: FlutterFlowTheme.of(context).white,
          size: 28.0,
        ),
      ),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Text(
          'New Chats ?',
          style: FlutterFlowTheme.of(context).displaySmall.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).white,
              ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: 53.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: Image.asset(
                    'assets/images/waves@2x.png',
                  ).image,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
              child: Text(
                'Chats',
                style: FlutterFlowTheme.of(context).titleSmall,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FireStoreConstance.threadCollection)
                      .doc(FirebaseUtil.sessionModel.uid)
                      .collection(FireStoreConstance.chatsCollection)
                      .snapshots(),
                  builder: (context, snapshot) {

                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text("Loading ..."));
                    }

                    if(snapshot.connectionState == ConnectionState.active) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            Map<String, dynamic> data =
                            snapshot.data!.docs[index].data() as Map<
                                String,
                                dynamic>;

                            final ThreadModel threadModel = ThreadModel.fromJson(
                                data);
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 8.0),
                              child: InkWell(
                                onTap: () async =>
                                await _onOpenThread(threadModel),
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme
                                        .of(context)
                                        .secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color: Color(0x230E151B),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 12.0, 0.0, 12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${threadModel.title}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: FlutterFlowTheme
                                                .of(context)
                                                .headlineMedium
                                                .copyWith(fontSize: 14.0),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color:
                                          FlutterFlowTheme
                                              .of(context)
                                              .primary,
                                          onPressed: () async =>
                                          await _onDeleteThread(threadModel.id!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['containerOnPageLoadAnimation']!),
                            );
                          });
                    }
                    return const Center(child: Text('ssss'));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future _onOpenThread(ThreadModel threadModel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewChatsScreen(
          threadName: threadModel.title!,
          threadId: threadModel.id!,
          isHistory: true,
        ),
      ),
    );
  }

  Future _onDeleteThread(String id) async {
    await FirebaseUtil.deleteThread(id);
  }
}
