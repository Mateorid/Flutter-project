import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_sitting/widgets/global_snack_bar.dart';

Future<void> handleAsyncOperation(
    {required Future<dynamic> asyncOperation,
    required String onSuccessText,
    required BuildContext context}) async {
  try {
    await asyncOperation;
    GlobalSnackBar.showAlertSuccess(
        context: context, bigText: "Success", smallText: onSuccessText);
  } on FirebaseAuthException catch (e) {
    GlobalSnackBar.showAlertError(
        context: context,
        bigText: "Error",
        smallText: e.message ?? 'Unknown error occurred');
  } catch (e) {
    GlobalSnackBar.showAlertError(
        context: context,
        bigText: "Error",
        smallText: 'Unknown error, please try again later');
  }
}
