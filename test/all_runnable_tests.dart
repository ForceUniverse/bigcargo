import 'package:scheduled_test/scheduled_test.dart';
import 'package:bigcargo/bigcargo.dart';

import 'logic/export_tests.dart';

void main() {
  Cargo storage = new Cargo(MODE: CargoMode.MONGODB, collection: "store", conf: { "address": "mongodb://127.0.0.1/test" });

  storage.start().then((_) {
    storage.clear().then((_) {
      group('mongoDB exports', () {
        runExports(storage, "mongoDB");
      });
    });
  });
  
}