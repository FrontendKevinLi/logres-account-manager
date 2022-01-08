import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:logres_account_manager/constant.dart';
import 'package:logres_account_manager/main.dart';
import 'package:get/get.dart';
import 'package:logres_account_manager/screens/AccountInfoCreateScreen.dart';
import 'package:logres_account_manager/types/AccountInfo.dart';

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({
    Key? key,
    this.accountInfo = const AccountInfo(),
  }) : super(key: key);

  final AccountInfo accountInfo;

  @override
  Widget build(BuildContext context) {
    AccountController accountController = Get.put(AccountController());

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(accountInfo.name),
                TextButton(
                  child: Text('Delete'),
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete account'),
                        content: Text(
                            'Are you sure you want to delete this account?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                              accountController.deleteAccount(accountInfo.id);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            subtitle: Text(this.accountInfo.accountId),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Get.to(AccountInfoCreateScreen(
                    accountInfo: accountInfo,
                    actionType: ActionType.Edit,
                  ));
                },
                child: Text('Edit'),
                style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.only(right: 8))),
              ),
              Row(
                children: [
                  TextButton(
                    child: Text('Copy ID'),
                    onPressed: () {
                      FlutterClipboard.copy(this.accountInfo.accountId)
                          .then((value) => print('Copied ${this.accountInfo.accountId}'));
                    },
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    child: Text('Copy Password'),
                    onPressed: () {
                      FlutterClipboard.copy(this.accountInfo.password)
                          .then((value) => print('Copied ${this.accountInfo.password}'));
                    },
                  ),
                  SizedBox(width: 8),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
