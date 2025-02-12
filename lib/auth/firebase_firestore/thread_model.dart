class ThreadModel {
  String? id;
  String? title;

  List<ChatModel>? chatList;

  ThreadModel(this.id, this.title, this.chatList);

  ThreadModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    List list = json['chatList'] ?? [];
    chatList = list.map((e) => ChatModel.fromJson(e)).toList();
  }
}

class ChatModel {
  String? message;

  bool? isUser;

  ChatModel(this.message, this.isUser);

  ChatModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isUser = json['isUser'];
  }
}
