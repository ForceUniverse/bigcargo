part of bigcargo;

/// Factory class for all the nosql cargo implementations
abstract class Cargo extends CargoBase with CargoDispatch {
  Cargo._();
  /// Create a new cargo storage
  factory Cargo({CargoModeHolder MODE: CargoMode.MEMORY, Map conf, String collection: ""}) {
      print("Initiating a cargo storage with ${MODE} backend");
      
      switch(MODE) {
        case CargoMode.MEMORY:
          return new MemoryCargo(collection: collection);
        case CargoMode.MONGODB:
          return new MongoCargo(conf!=null ? conf["address"] : "", collection: collection);
        case CargoMode.REDIS:
          return new RedisCargo(conf!=null ? conf["address"] : "", collection: collection);
        default:
          Logger.root.warning("Error: Unsupported storage backend \"${MODE}\", supported backends on server is: ${CargoMode.MEMORY} and ${CargoMode.MONGODB}");
      }
    }
  
}

