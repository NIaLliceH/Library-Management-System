import 'package:frontend/models/user.dart';

User thisUser = User(
    id: '',
    name: '',
    email: '',
    avatarUrl: '',
    gender: '',
    address: '',
    phoneNum: ''
); // fake data since WidgetsFlutterBinding.ensureInitialized() is called

void test({String id = '1'}) {
  print('test $id');
}