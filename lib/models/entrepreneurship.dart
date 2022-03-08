import 'dart:convert';

class Entrepreneurship {
  Entrepreneurship({
    required this.be_on_kit,
    //required this.commission,
    required this.descripcion_emp,
    required this.entrepreneurship_na,
    required this.id_user,
    required this.logo,
    this.max_discount,
    this.min_discount,
    this.raw_materials,
    this.sociaMedia,
    this.id,
  });

  String be_on_kit;
  //int commission;
  String descripcion_emp;
  String entrepreneurship_na;
  String id_user;
  String? logo;
  String? max_discount;
  String? min_discount;
  String? raw_materials;
  String? sociaMedia;
  String? id;

  factory Entrepreneurship.fromJson(String str) =>
      Entrepreneurship.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Entrepreneurship.fromMap(Map<String, dynamic> json) =>
      Entrepreneurship(
        id: json["_id"],
        be_on_kit: json["be_on_kit"],
        //commission: json["commission"],
        descripcion_emp: json["descripcion_emp"],
        entrepreneurship_na: json["entrepreneurship_name"],
        id_user: json["id_user"],
        logo: json["logo"],
        max_discount: json["max_discount"],
        min_discount: json["min_discount"],
        raw_materials: json["raw_materials"],
        sociaMedia: json["user_social_media"],
      );

  Map<String, dynamic> toMap() => {
        "be_on_kit": be_on_kit,
        //"commission": commission,
        "descp_emp": descripcion_emp,
        "entrepreneurship_name": entrepreneurship_na,
        "id_user": id_user,
        "logo": logo,
        "max_discount": max_discount,
        "min_discount": min_discount,
        "raw_materials": raw_materials,
        "user_social_media": sociaMedia,
      };
}
