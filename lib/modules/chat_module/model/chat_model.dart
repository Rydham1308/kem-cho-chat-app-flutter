class ChatModel {
  String? msg;
  String? senderId;
  String? receiverId;
  String? timeStamp;

  ChatModel({this.msg, this.receiverId, this.senderId, this.timeStamp});

  ChatModel.fromJson(Map<String, dynamic> json)
      : msg = json['msg'],
        senderId = json['senderId'],
        receiverId = json['receiverId'],
        timeStamp = json['timeStamp'];

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'senderId': senderId,
      'receiverId': receiverId,
      'timeStamp': timeStamp,
    };
  }
}
