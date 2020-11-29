class User {
  String documentID;
  String name;
  String surname;
  String email;

  User({this.name, this.surname, this.email});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = name;
    data["surname"] = surname;
    data["email"] = email;
    return data;
  }

  void setDocumentID(documentID) {
    this.documentID = documentID;
  }
}
