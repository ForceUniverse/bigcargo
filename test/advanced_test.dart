import 'package:unittest/unittest.dart';
import 'package:bigcargo/bigcargo.dart';

void main() {
  // First tests!
  Cargo storage = new Cargo(MODE: CargoMode.MONGODB, conf: {"collection": "store", "address": "mongodb://127.0.0.1/test" });

    storage.start().then((_) {
      test('test basic json storage access', () {
        storage.clear();
        
        Map asyncData = {"as": "go"};

        storage.setItem("someValue", asyncData).then((_) {
            storage.getItem("someValue").then((value) 
                       => expect(value, asyncData)
                     );
        });
        
        storage.setItem("adv", {"as": "go"}).then((_) {
                    storage.getItem("someValue").then((value) 
                               => expect(value, {"as": "go"})
                             );
        });
        
        // now update data
        storage["someValue"] = {"value": "whoepa"};
      });
    });

}
