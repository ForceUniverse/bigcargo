## BigCargo ##

An abstraction implementation of Cargo on nosql databases

### Simple usage ###

For the moment we have only a MongoDB implementation. Please take a look at the test examples.

Or just look at this.

	Cargo storage = new Cargo(MODE: CargoMode.MONGODB, collection: "store", conf: {"address": "mongodb://127.0.0.1/test" });

  	storage.start().then((_) {
      storage.clear();
      storage["someValue"] = {"value": "go"};

      storage.getItem("someValue").then((value) {
        // do something with the retrieved value!
      });
  	});
  	
### Implementations ###

We have implemenations for:

- MongoDB
- Redis (experimental)

### Contributing ###
 
If you found a bug, just create a new issue or even better fork and issue a
pull request with you fix.

### Join our discussion group ###

[Google group](https://groups.google.com/forum/#!forum/dart-force)

### Social media ###

#### Twitter ####

Follow us on twitter https://twitter.com/usethedartforce

#### Google+ ####

Follow us on [google+](https://plus.google.com/111406188246677273707)

or join our [G+ Community](https://plus.google.com/u/0/communities/109050716913955926616) 