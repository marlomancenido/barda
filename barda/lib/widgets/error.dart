import 'package:flutter/material.dart';

// ERROR HANDLING WIDGET
// Handles all errors/success snackbars.
// This is called when making error/succes snackbars.

showError(BuildContext context, var errorcode, String errormessage) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      key: Key('error_snbar'),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Error $errorcode.',
          style:
              const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          children: <TextSpan>[
            TextSpan(
                text: ' $errormessage',
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.white)),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      width: MediaQuery.of(context).size.width * 0.8));
}

showSuccess(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      key: Key('success_snbar'),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Success!',
          style:
              const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          children: <TextSpan>[
            TextSpan(
                text: ' $message',
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.white)),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      width: MediaQuery.of(context).size.width * 0.8));
}
