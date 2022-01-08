import 'package:hive/hive.dart';

part 'AccountInfo.g.dart';

@HiveType(typeId: 1)
class AccountInfo {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String accountId;

  @HiveField(3)
  final String password;

  const AccountInfo({
    this.id = '0',
    this.name = '',
    this.accountId = '',
    this.password = '',
  });
}
