import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_sitting/widgets/global_snack_bar.dart';

Future<bool> handleAsyncOperation(
    {required Future<dynamic> asyncOperation,
    required String onSuccessText,
    required BuildContext context}) async {
  try {
    await asyncOperation;
    GlobalSnackBar.showAlertSuccess(
        context: context, bigText: "Success", smallText: onSuccessText);
    return true;
  } on FirebaseAuthException catch (e) {
    GlobalSnackBar.showAlertError(
        context: context,
        bigText: "Error",
        smallText: e.message ?? 'Unknown error occurred');
    return false;
  } catch (e) {
    GlobalSnackBar.showAlertError(
        context: context, bigText: "Error", smallText: '$e');
    return false;
  }
}
