import 'package:zsquadfitness/core/constants/app_strings.dart';

//Phonenr validation set to start with 07 and digits only
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return AppStrings.needPhoneNr;
  }

  final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (!RegExp(r'^07[0-9]{8}$').hasMatch(digitsOnly)) {
    return AppStrings.phoneLength;
  }
  return null;
}
