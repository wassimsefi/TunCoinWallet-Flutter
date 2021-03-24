// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));
String transactionToJson(User data) => json.encode(data.toJson());

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
    this.isConfimed,
  });

  List<Transaction> transaction;
  String id;
  String email;
  String password;
  int balance;
  bool isConfimed;

  factory User.fromJson(Map<String, dynamic> json) => User(
        transaction: List<Transaction>.from(
            json["transaction"].map((x) => Transaction.fromJson(x))),
        id: json["_id"],
        email: json["email"],
        password: json["password"],
        balance: json["balance"],
        isConfimed: json["isConfimed"],
      );

  Map<String, dynamic> toJson() => {
        "transaction": List<dynamic>.from(transaction.map((x) => x.toJson())),
        "_id": id,
        "email": email,
        "password": password,
        "balance": balance,
        "isConfimed": isConfimed,
      };
}

class Transaction {
  Transaction({
    this.date,
    this.typeTransaction,
    this.secondUser,
    this.amount,
  });

  DateTime date;
  String typeTransaction;
  String secondUser;
  int amount;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        date: DateTime.parse(json["date"]),
        typeTransaction: json["typeTransaction"],
        secondUser: json["secondUser"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "typeTransaction": typeTransaction,
        "secondUser": secondUser,
        "amount": amount,
      };
}
