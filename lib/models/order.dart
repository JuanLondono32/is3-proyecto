import 'dart:convert';

class Order {
  Order({
    this.address,
    required this.idUser,
    required this.idEmp,
    required this.mail,
    required this.orderDate,
    required this.status,
    required this.tax,
    required this.totalPrice,
    this.id,
  });

  String? address;
  String idUser;
  String idEmp;
  String mail;
  DateTime orderDate;
  String status;
  int tax;
  int totalPrice;
  String? id;

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        address: json["address"],
        idUser: json["id_user"],
        idEmp: json["id_emp"],
        mail: json["mail"],
        orderDate: DateTime.parse(json["order_date"]),
        status: json["status"],
        tax: json["tax"],
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "id_user": idUser,
        "mail": mail,
        "id_emp": idEmp,
        "order_date":
            "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "tax": tax.toString(),
        "total_price": totalPrice.toString(),
      };
}
