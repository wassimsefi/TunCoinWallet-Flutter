// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.user,
  });

  User user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class User {
  User({
    this.transaction,
    this.id,
    this.email,
    this.password,
    this.balance,
    this.v,
  });

  List<Transaction> transaction;
  String id;
  String email;
  String password;
  int balance;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
        transaction: List<Transaction>.from(
            json["transaction"].map((x) => Transaction.fromJson(x))),
        id: json["_id"],
        email: json["email"],
        password: json["password"],
        balance: json["balance"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "transaction": List<dynamic>.from(transaction.map((x) => x.toJson())),
        "_id": id,
        "email": email,
        "password": password,
        "balance": balance,
        "__v": v,
      };
}

class Transaction {
  Transaction({
    this.date,
    this.type,
    this.secondUser,
    this.amount,
  });

  String date;
  String type;
  String secondUser;
  String amount;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        date: json["date"],
        type: json["type"],
        secondUser: json["secondUser"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "type": type,
        "secondUser": secondUser,
        "amount": amount,
      };
}
