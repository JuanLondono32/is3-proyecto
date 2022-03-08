import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecoshops/models/detailOrder.dart';
import 'package:flutter_ecoshops/models/models.dart';
import 'package:flutter_ecoshops/models/order.dart';
import 'package:flutter_ecoshops/models/user.dart';
import 'package:flutter_ecoshops/repositories/order_repository.dart';
import 'package:flutter_ecoshops/repositories/product_repository.dart';

class OrderService extends ChangeNotifier {
  final List<DetailOrder> orders = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProductRepository _productRepository = ProductRepository();
  final OrderRepository _orderRepository = OrderRepository();

  OrderService();

  void addDetail(String productID, int amount, Product product) {
    var newDetail = new DetailOrder(
        amount: amount,
        finalPrice: amount * product.price,
        idProduct: productID,
        product: product);
    orders.add(newDetail);
  }

  int getTotal() {
    var total = 0;
    orders.forEach((ord) {
      total = total + ord.finalPrice;
    });
    return total;
  }

  Future sendOrder(Account user, String entID) async {
    // Creando nueva orden
    var newOrder = Order(
        address: user.address ?? "",
        idUser: user.id!,
        mail: user.mail,
        idEmp: entID,
        orderDate: DateTime.now(),
        status: "Confirmación pendiente.",
        tax: 19,
        totalPrice: this.getTotal());

    print(orders);
    final orderResp = await _orderRepository.registerOrder(newOrder.toMap());
    print('orderResp');
    print(orderResp);
    // // Insertando detalles de orden
    await Future.forEach(orders, (DetailOrder ord) async {
      Map ordMap = ord.toMap();
      ordMap["id_order"] = orderResp["_id"];
      await _orderRepository.registerDetailOrder(ordMap);
    });
    orders.removeWhere((element) => true);
  }

  Future<List> getOrders(String userID) async {
    try {
      List ordersList = [];
      List productsOrder = [];
      final ordenes = await _orderRepository.getMyorders(userID);
      await Future.forEach<Map<String, dynamic>>(ordenes, (orden) async {
        final detallesOrden =
            await _orderRepository.getDetailsOrder(orden["_id"]);
        Map<String, dynamic> ordenModified = orden;
        await Future.forEach<Map<String, dynamic>>(detallesOrden,
            (detalle) async {
          final producto =
              await _productRepository.getProduct(detalle["id_product"]);
          productsOrder.add(producto);
        });
        ordenModified["products"] = productsOrder;
        ordersList.add(ordenModified);
        productsOrder = [];
      });
      // var order = _firestore.collection("order");
      // var userOrders = await order.where("id_user", isEqualTo: userID).get();
      // await Future.forEach(userOrders.docs,
      //     (QueryDocumentSnapshot element) async {
      //   Map dato = element.data() as dynamic;
      //   dato["products"] = [];
      //   var detalles = await FirebaseFirestore.instance
      //       .collection("order")
      //       .doc(element.id)
      //       .collection("detail_order")
      //       .get();
      //   await Future.forEach(detalles.docs,
      //       (QueryDocumentSnapshot element2) async {
      //     Map elementData = element2.data() as dynamic;
      //     var producto = await FirebaseFirestore.instance
      //         .collection("product")
      //         .doc(elementData["id_product"])
      //         .get();
      //     var dataProducto = producto.data();
      //     dato["products"].add(dataProducto!["name_prod"]);
      //   });
      // ordersList.add(dato);
      // });
      // return resp;
      return ordersList;
    } catch (e) {
      print('error main $e');
      return [];
    }
  }

  Future<List> getOrdersByEnt(String entID) async {
    List ordersList = [];
    List productsOrder = [];
    final ordenes = await _orderRepository.getMyorders(entID);
    await Future.forEach<Map<String, dynamic>>(ordenes, (orden) async {
      num orderValue = 0;
      final detallesOrden =
          await _orderRepository.getDetailsOrder(orden["_id"]);
      Map<String, dynamic> ordenModified = orden;
      await Future.forEach<Map<String, dynamic>>(detallesOrden,
          (detalle) async {
        final producto =
            await _productRepository.getProduct(detalle["id_product"]);
        if (producto["id_emprendimiento"] == entID) {
          productsOrder.add(producto);
          orderValue += num.parse(producto['price']);
        }
      });
      ordenModified["products"] = productsOrder;
      ordenModified["total_price"] = orderValue;
      ordersList.add(ordenModified);
      productsOrder = [];
    });
    // await Future.forEach(userOrders.docs,
    //     (QueryDocumentSnapshot element) async {
    //   Map dato = element.data() as dynamic;
    //   dato["products"] = [];
    //   bool flag = false;
    //   var detalles = await FirebaseFirestore.instance
    //       .collection("order")
    //       .doc(element.id)
    //       .collection("detail_order")
    //       .get();
    //   await Future.forEach(detalles.docs,
    //       (QueryDocumentSnapshot element2) async {
    //     Map elementData = element2.data() as dynamic;
    //     var producto = await FirebaseFirestore.instance
    //         .collection("product")
    //         .doc(elementData["id_product"])
    //         .get();
    //     var dataProducto = producto.data() as dynamic;
    // if (dataProducto["id_entrepreneurship"] == entID) {
    //   flag = true;
    //   dato["products"].add(dataProducto!["name_prod"]);
    // }
    //   });
    //   if (flag) {
    //     ordersList.add(dato);
    //   }
    // });
    return ordersList;
  }
}
