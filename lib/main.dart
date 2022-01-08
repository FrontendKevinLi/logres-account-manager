import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logres_account_manager/widgets/AccountInfoCard.dart';
import 'constant.dart';
import 'types/AccountInfo.dart';
import 'package:get/get.dart';
import 'package:logres_account_manager/screens/AccountInfoCreateScreen.dart';

void main() async {
  Hive.registerAdapter(AccountInfoAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Constant.apptitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => MyHomePage(),
        '/account-info-create': (context) => AccountInfoCreateScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void getAccountInfoList() async {
    await Hive.initFlutter();
    var dataBox = await Hive.openBox('data');
    List<dynamic>? accountInfoList = dataBox.get('accountInfoList');
    if (accountInfoList == null) return;

    final Controller controller = Get.put(Controller());
    controller.initAccountList(accountInfoList
        .map((accountInfo) => new AccountInfo(
              id: accountInfo?.id,
              name: accountInfo?.name,
              accountId: accountInfo?.accountId,
              password: accountInfo?.password,
            ))
        .toList());
  }

  @override
  void initState() {
    super.initState();
    this.getAccountInfoList();
  }

  @override
  Widget build(BuildContext context) {
    final Controller controller = Get.put(Controller());

    return Scaffold(
        appBar: AppBar(
          title: Text(Constant.apptitle),
        ),
        body: Obx(() => ListView(
              children: controller.accountInfoList
                  .map((accountInfo) => AccountInfoCard(
                        key: Key(accountInfo.id),
                        accountInfo: accountInfo,
                      ))
                  .toList(),
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(AccountInfoCreateScreen(actionType: ActionType.Add,));
            print('Pressed add');
          },
          child: Icon(Icons.add),
        ));
  }
}

class Controller extends GetxController {
  RxList<AccountInfo> accountInfoList = <AccountInfo>[].obs;

  void initAccountList(List<AccountInfo> newAccountInfoList) {
    accountInfoList.value = newAccountInfoList;
  }

  void addNewAccount(AccountInfo accountInfo) {
    accountInfoList.add(accountInfo);
  }

  Future deleteAccount(String id) async {
    if (accountInfoList.isEmpty) return;

    accountInfoList.value = accountInfoList.where((accountInfo) => accountInfo.id != id).toList();
    
    _updateAccountInfoListInHive();
  }

  Future editAccount(AccountInfo editedAccountInfo) async {
    if (accountInfoList.isEmpty) return;

    final int accountInfoIndex = accountInfoList.indexWhere((accountInfo) => accountInfo.id == editedAccountInfo.id);
    if (accountInfoIndex == -1) return;

    accountInfoList.removeAt(accountInfoIndex);
    accountInfoList.insert(accountInfoIndex, editedAccountInfo);

    _updateAccountInfoListInHive();
  }

  Future _updateAccountInfoListInHive() async {
    Hive.initFlutter();
    final Box dataBox = await Hive.openBox('data');
    dataBox.put('accountInfoList', accountInfoList);
  }
}
