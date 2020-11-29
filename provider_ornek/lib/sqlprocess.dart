import 'package:flutter/material.dart';
import 'package:provider_ornek/processtype.dart';
import 'custom_dialog.dart';
import 'user.dart';

class SqlProcess {
  insertProcessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          user: new User(),
          processType: ProcessType.INSERT,
        );
      },
    );
  }

  updateProcessDialog(BuildContext context, User currentUser) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          user: currentUser,
          buttonText: 'Güncelle',
          processType: ProcessType.UPDATE,
        );
      },
    );
  }
}
