class UserModel {
  String? email;
  String? pass;
  String? name;
  String? key;
  List<Map<String, dynamic>>? chatIds;

  UserModel({
    this.email,
    this.pass,
    this.name,
    this.key,
    this.chatIds,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        pass = json['pass'],
        name = json['name'],
        key = json['key'],
        chatIds = ((json['chatIds'] ?? []) as List<dynamic>)
            .map((e) => (e ?? {}) as Map<String, dynamic>)
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'pass': pass,
      'name': name,
      'key': key,
      'chatIds': chatIds,
    };
  }
}
