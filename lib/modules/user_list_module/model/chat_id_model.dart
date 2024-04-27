class ChatIdsModel {
  String? userOneId;
  String? userOneName;
  // String? userTwoId;
  // String? userTwoName;
  String? connectionKey;

  ChatIdsModel({
    this.userOneId,
    this.userOneName,
    // this.userTwoId,
    // this.userTwoName,
    this.connectionKey,
  });

  ChatIdsModel.fromJson(Map<String, dynamic> json)
      : userOneName = json['userOneName'],
        userOneId = json['userOneId'],
        // userTwoId = json['userTwoId'],
        // userTwoName = json['userTwoName'],
        connectionKey = json['connectionKey'];

  Map<String, dynamic> toJson() {
    return {
      'userId': userOneId,
      'userOneName': userOneName,
      // 'userTwoId': userTwoId,
      // 'userTwoName': userTwoName,
      'connectionKey': connectionKey,
    };
  }
}