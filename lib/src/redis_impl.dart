part of bigcargo;

class RedisCargo extends Cargo {
    Completer _completer;
    
    RedisClient redis_client;
    
    String address;
    
    RedisCargo(this.address, {String collection: "base"}) : super._() {
      _completer = new Completer();
      this.collection = collection;
    }
    
    Future withCollection(collection) {
      this.collection = collection;
         
      return new Future.value();
    }
          
    CargoBase instanceWithCollection(String collection) {
      return new RedisCargo(this.address, collection: collection);
    }

    dynamic getItemSync(String key, {defaultValue}) {
      throw new UnsupportedError('Redis is not supporting synchronous retrieval of data, we will add this feature when await key is available in Dart');
    }
    
    dynamic _setDefaultValue(String key, defaultValue) {
        if (defaultValue != null) {
          setItem(key, defaultValue);
        }
        return defaultValue;
      }

    Future<dynamic> getItem(String key, {defaultValue}) {
      Completer complete = new Completer();
      key = "$collection$key";
      Future elem = redis_client.get(key).then((value) {
        if (value==null) {
          value = _setDefaultValue(key, defaultValue);
        }
        complete.complete(JSON.decode(value));
      });
      return complete.future;      
    }

    Future setItem(String key, value) {
       key = "$collection$key";
       return _setItem(key, value);
    }
    
    Future _setItem(String key, value) {
       return redis_client.set(key, JSON.encode(value)).then((_) {
         dispatch(key, value);
       });
    }
    
    void add(String key, data) {
      List list = new List();
      key = "$collection$key";
      redis_client.exists(key).then((exists) {
        if (exists) {
          getItem(key).then((value) {
            if (value is List) {
              list = value;
              
              _add(list, key, data);
            }
          });
        } else {
          _add(list, key, data);
        }
      });
     }
    
    void _add(List list, String key, data) {
        list.add(data);
        
        _setItem(key, list);
    }

    void removeItem(String key) {
      key = "$collection$key";
      _removeItem(key);
    }
        
    
    void _removeItem(String key) {
      redis_client.del(key);
      dispatch_removed(key);
    }

    Future clear() {
      return redis_client.flushdb();
    }

    Future<int> length() {
      return redis_client.dbsize;
    }
    
    Map exportSync({Map params}) {
      throw new UnsupportedError('Redis implementation not ready to use this function!');
    }
     
    Future<Map> export({Map params}) {
      throw new UnsupportedError('Redis implementation not ready to use this function!');
    }

    Future start() {
      RedisClient.connect(this.address)
            .then((RedisClient client) {
          
          redis_client = client;
          //redis_client.
        
          _completer.complete();
        });
      return _completer.future;
    }
}