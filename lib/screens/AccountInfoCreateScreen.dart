import 'package:flutter/material.dart';
import 'package:logres_account_manager/constant.dart';
import 'package:logres_account_manager/main.dart';
import 'package:logres_account_manager/types/AccountInfo.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AccountInfoCreateScreen extends StatefulWidget {
  AccountInfoCreateScreen({
    Key? key,
    this.accountInfo = const AccountInfo(),
    this.actionType = ActionType.Add,
  }) : super(key: key);

  final AccountInfo accountInfo;
  final ActionType actionType;

  @override
  _AccountInfoCreateScreenState createState() =>
      _AccountInfoCreateScreenState();
}

class _AccountInfoCreateScreenState extends State<AccountInfoCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController accountIdEditingController =
      TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  String appBarTitle = '';
  String confirmButtonLabel = '';
  Future Function(Controller controller) confirmButtonCallback =
      (Controller controller) async {};

  void _initEditingControllers() {
    nameEditingController.text = widget.accountInfo.name;
    accountIdEditingController.text = widget.accountInfo.accountId;
    passwordEditingController.text = widget.accountInfo.password;
  }

  void _initByActionType() {
    if (widget.actionType == ActionType.Add) {
      appBarTitle = 'Add New Account';
      confirmButtonLabel = 'Add';
      return;
    }
    if (widget.actionType == ActionType.Edit) {
      appBarTitle = 'Edit Account';
      confirmButtonLabel = 'Edit';
      return;
    }
  }

  Future _addNewAccount(Controller controller) async {
    Uuid uuid = Uuid();
    final newAccountInfo = AccountInfo(
      id: uuid.v4(),
      name: nameEditingController.text,
      accountId: accountIdEditingController.text,
      password: passwordEditingController.text,
    );
    controller.addNewAccount(newAccountInfo);

    await Hive.initFlutter();
    var dataBox = await Hive.openBox('data');
    List<AccountInfo> accountInfoList = controller.accountInfoList;
    dataBox.put('accountInfoList', accountInfoList);
    Get.back();
  }

  Future _editAccount(
    Controller controller,
    AccountInfo editedAccountInfo,
  ) async {
    controller.editAccount(editedAccountInfo);
    Get.back();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initEditingControllers();
    _initByActionType();
  }

  @override
  Widget build(BuildContext context) {
    final Controller controller = Get.put(Controller());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                autofocus: true,
                controller: nameEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter character name',
                  labelText: 'Character name',
                ),
              ),
              TextFormField(
                controller: accountIdEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter account ID',
                  labelText: 'Account ID',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
                child: TextFormField(
                  controller: passwordEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter passwrod',
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (widget.actionType == ActionType.Add) {
                        _addNewAccount(controller);
                        return;
                      }
                      if (widget.actionType == ActionType.Edit) {
                        AccountInfo editedAccountInfo = AccountInfo(
                          id: widget.accountInfo.id,
                          name: nameEditingController.text,
                          accountId: accountIdEditingController.text,
                          password: passwordEditingController.text,
                        );
                        _editAccount(controller, editedAccountInfo);
                      }
                    },
                    child: Text(confirmButtonLabel),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
