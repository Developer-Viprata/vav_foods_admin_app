import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GetAutoIdController extends GetxController {
  String generateId() {
    var uuid = Uuid();
    String id = uuid.v4();
    return id;
  }
}
