part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final String? beOnKits;
  final String? descRawMaterial;
  final String? minDisc;
  final String? maxDisc;
  final String? entrepreneurshiName;
  final String? userSocialMedia;
  final String? descpEmp;
  final FormStatus isSubmittedSuccess;

  RegisterState(
      {this.beOnKits,
      this.descRawMaterial,
      this.minDisc,
      this.maxDisc,
      this.entrepreneurshiName,
      this.userSocialMedia,
      this.isSubmittedSuccess = FormStatus.noSubmitted,
      this.descpEmp});

  RegisterState copyWith(
      {String? beOnKits,
      String? descRawMaterial,
      String? minDisc,
      String? maxDisc,
      String? entrepreneurshiName,
      String? userSocialMedia,
      FormStatus? isSubmittedSuccess,
      String? descpEmp}) {
    return RegisterState(
        beOnKits: beOnKits ?? this.beOnKits,
        descRawMaterial: descRawMaterial ?? this.descRawMaterial,
        minDisc: minDisc ?? this.minDisc,
        maxDisc: maxDisc ?? this.maxDisc,
        entrepreneurshiName: entrepreneurshiName ?? this.entrepreneurshiName,
        userSocialMedia: userSocialMedia ?? this.userSocialMedia,
        isSubmittedSuccess: isSubmittedSuccess ?? this.isSubmittedSuccess,
        descpEmp: descpEmp ?? this.descpEmp);
  }

  Map<String, String> toJson() => {
        "be_on_kit": beOnKits ?? '',
        "max_discount": minDisc ?? '',
        "min_discount": maxDisc ?? '',
        "entrepreneurship_name": entrepreneurshiName ?? '',
        "user_social_media": userSocialMedia ?? '',
        "descp_emp": descpEmp ?? '',
      };

  @override
  List<Object?> get props => [
        beOnKits,
        descRawMaterial,
        minDisc,
        maxDisc,
        entrepreneurshiName,
        userSocialMedia,
        isSubmittedSuccess,
        descpEmp,
      ];
}
