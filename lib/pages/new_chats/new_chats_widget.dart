import 'package:dart_openai/dart_openai.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:smartai/auth/firebase_firestore/thread_model.dart';
import '../../auth/firebase_firestore/firestore_util.dart';
import '../../backend/api.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/main.dart';
import 'package:flutter/material.dart';
import 'new_chats_model.dart';
export 'new_chats_model.dart';

class NewChatsScreen extends StatefulWidget {
  final String threadName;
  final String threadId;
  final bool isHistory;

  const NewChatsScreen(
      {Key? key,
        required this.threadName,
        required this.threadId,
        required this.isHistory})
      : super(key: key);

  @override
  _NewChatsScreenState createState() => _NewChatsScreenState();
}

class _NewChatsScreenState extends State<NewChatsScreen> {
  late NewChatsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<ChatModel> _chatList = [];
  final ScrollController _controller = ScrollController();
  bool _isTyping = false;
  bool _isLoading = false;
  final ApiService _apiService = ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewChatsModel());
    _model.textController ??= TextEditingController();

    if (widget.isHistory) {
      _getChatModel();
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const NavBarPage(initialPage: 'myChats'),
                ),
              );
            },
          ),
          title: Text(
            widget.threadName,
            textAlign: TextAlign.start,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22.0,
            ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        bottomSheet:
        widget.isHistory ? const SizedBox() : _inputMessageWidget(context),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                const SizedBox(
                  height: 16,
                ),
                ListView.builder(
                    itemCount: _chatList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final ChatModel chatModel = _chatList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: chatModel.isUser!
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: chatModel.isUser!
                                    ? Colors.grey.shade300
                                    : FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                child: _buildMessageText(chatModel, index),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageText(ChatModel chatModel, int index) {
    if (_isTyping && _chatList.length == index + 1 && !_chatList.last.isUser!) {
      return AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            '${chatModel.message}',
            textStyle: TextStyle(
                color: chatModel.isUser! ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight:
                chatModel.isUser! ? FontWeight.w400 : FontWeight.w500),
            speed: const Duration(milliseconds: 30),
          ),
        ],
        totalRepeatCount: 1,
        pause: const Duration(minutes: 1000),
        displayFullTextOnTap: false,
        stopPauseOnTap: false,
        onFinished: () {
          setState(() {
            _isTyping = false;
          });
        },
      );
    }

    return Text(
      '${chatModel.message}',
      style: TextStyle(
          color: chatModel.isUser! ? Colors.black : Colors.white,
          fontSize: 16,
          fontWeight: chatModel.isUser! ? FontWeight.w400 : FontWeight.w500),
    );
  }

  Widget _inputMessageWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: TextFormField(
        controller: _model.textController,
        autofocus: true,
        obscureText: false,
        decoration: InputDecoration(
          hintText: 'New Message',
          hintStyle: FlutterFlowTheme.of(context)
              .titleLarge
              .override(fontFamily: 'Lato'),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 5,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 5,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 5,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 5,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          suffixIcon: _isLoading
              ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeAlign: -5.0),
          )
              : IconButton(
            icon: const Icon(Icons.send),
            color: FlutterFlowTheme.of(context).primary,
            onPressed: () async => await _onSendMessage(),
          ),
          suffix: _isTyping
              ? const Padding(
            padding: EdgeInsets.all(11.0),
            child: CircularProgressIndicator(strokeAlign: -5.0),
          )
              : IconButton(
            icon: const Icon(Icons.stop_circle),
            color: FlutterFlowTheme.of(context).primary,
            onPressed: () async => await _ontapying(),
          ),
        ),
        style: FlutterFlowTheme.of(context).bodyLarge.override(
          fontFamily: 'Outfit',
          fontSize: 22.0,
        ),
        textAlign: TextAlign.start,
        validator: _model.textControllerValidator.asValidator(context),
      ),
    );
  }

  Future _onSendMessage() async {
    if (_model.textController.text.isEmpty) {
      return;
    }

    final ChatModel chatModel = ChatModel(_model.textController.text, true);
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _chatList.add(chatModel);
      _isLoading = true;
    });

    await FirebaseUtil.sendNewMessage(
        id: widget.threadId, chatModel: chatModel);

    try {
      final response = await _apiService.getAnswer(_model.textController.text);
      final similarityScore = response['similarity_score'];
      final apiAnswer = response['answer'];

      if (similarityScore >= 0.5) {
        setState(() {
          _chatList.add(ChatModel(apiAnswer, false));
          _isLoading = false;
        });

        await FirebaseUtil.sendNewMessage(
          id: widget.threadId,
          chatModel: ChatModel(apiAnswer, false),
        );
      } else {await _useChatGPT();
      }
    } catch (e) {
      print('Error: $e');
      await _useChatGPT();
    }
  }

  Future _useChatGPT() async {
    try {
      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            _model.textController.text,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      );
      _model.textController!.clear();
      final chat = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo-0125",
        messages: [userMessage],
        seed: 6,
        temperature: 0.2,
        maxTokens: 500,
      );

      setState(() {
        _isTyping = true;
        _isLoading = false;

        _chatList.add(ChatModel(chat.choices.first.message.content?.first.text, false));
      });

      await FirebaseUtil.sendNewMessage(
        id: widget.threadId,
        chatModel: ChatModel(chat.choices.first.message.content?.first.text, false),
      );
    } catch (e) {
      print('ChatGPT API Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getChatModel() async {
    _chatList = await FirebaseUtil.getChatById(widget.threadId);
    setState(() {});
  }

  Future _ontapying() async {
    _isTyping = false;
  }
}
