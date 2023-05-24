import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_sitting/widgets/global_snack_bar.dart';

Future<T> handleAsyncOperation<T>({
  required Future<T> asyncOperation,
  required String onSuccessText,
  required BuildContext context,
}) async {
  try {
    T result = await asyncOperation;
    GlobalSnackBar.showAlertSuccess(
        context: context, bigText: "Success", smallText: onSuccessText);
    return result;
  } on FirebaseAuthException catch (e) {
    GlobalSnackBar.showAlertError(
        context: context,
        bigText: "Error",
        smallText: e.message ?? 'Unknown error occurred');
    rethrow;
  } catch (e) {
    GlobalSnackBar.showAlertError(
        context: context, bigText: "Error", smallText: '$e');
    rethrow;
  }
}
