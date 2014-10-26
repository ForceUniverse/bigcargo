part of bigcargo;

class RedisCargo extends Cargo {
    Completer _completer;
    
    RedisClient redis_client;
    
    String collectionName;
    String address;
    
    RedisCargo(this.collectionName, this.address) : super._() {
      _completer = new Completer();
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
      Future elem = redis_client.get(key).then((value) {
        if (value==null) {
          value = _setDefaultValue(key, defaultValue);
        }
        complete.complete(JSON.decode(value));
      });
      return complete.future;      
    }

    void setItem(String key, value) {
       redis_client.set(key, JSON.encode(value));
       dispatch(key, value);
    }
    
    void add(String key, data) {
      List list = new List(); 
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
        
        setItem(key, list);
    }

    void removeItem(String key) {
      redis_client.del(key);
    }

    void clear() {
      redis_client.flushdb();
    }

    Future<int> length() {
      return redis_client.dbsize;
    }
    
    Map exportSync() {
      throw new UnsupportedError('Redis implementation not ready to use this function!');
    }
     
    Future<Map> export() {
      throw new UnsupportedError('Redis implementation not ready to use this function!');
    }

    Future start() {
      RedisClient.connect(this.address)
            .then((RedisClient client) {
          
          redis_client = client;
        
          _completer.complete();
        });
      return _completer.future;
    }
}