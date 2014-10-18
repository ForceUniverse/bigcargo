import 'package:unittest/unittest.dart';
import 'package:bigcargo/bigcargo.dart';

void main() {
  // First tests!
  Cargo storage = new Cargo(MODE: CargoMode.MONGODB, conf: {"collection": "store", "address": "mongodb://127.0.0.1/test" });

  storage.start().then((_) {
    test('test basic json storage access', () {
      storage.clear();
      storage["someValue"] = {"value": "go"};

      storage.getItem("someValue").then((value) {
        expect(value, {"value": "go"});
      });
      
    });
  });
}
