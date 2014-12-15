part of bigcargo;

class MongoCargo extends Cargo {
    Completer _completer;
    Set keys = new Set();
    
    Db _db;
    DbCollection _collection;
    
    String address;
    
    MongoCargo(this.address, {String collection: "base", Db db}) : super._() {
      _completer = new Completer();
      this.collection = collection;
      this._db = db;
    }

    Future withCollection(collection) {
      this.collection = collection;
     
      // reset keys
      keys.clear();
      if (_db != null) {
        _collection = _db.collection(this.collection);
      }
      return new Future.value();
    }
      
    CargoBase instanceWithCollection(String collection) {
      return new MongoCargo(this.address, collection: collection, db: _db);
    }
    
    dynamic getItemSync(String key, {defaultValue}) {
      throw new UnsupportedError('MongoDB is not supporting synchronous retrieval of data, we will add this feature when await key is available in Dart');
    }
    
    dynamic _setDefaultValue(String key, defaultValue) {
        if (defaultValue != null) {
          setItem(key, defaultValue);
        }
        return defaultValue;
      }

    Future<dynamic> getItem(String key, {defaultValue}) {
      Completer complete = new Completer();
      Future elem = _collection.findOne(where.eq("key", key)).then((Map map) {
        var value;
        if (map==null||map["value"]==null) {
          value = _setDefaultValue(key, defaultValue);
        } else {
          value = JSON.decode(map["value"]);
        }
        complete.complete(value);
      });
      return complete.future;      
    }

    Future setItem(String key, value) {
       var data = [], rawData = {"key": key, "value": JSON.encode(value)};
       data.add(rawData);
       if (keys.contains(key)) {
        return Future.forEach(data,
              (elem){
                return _collection.update(where.eq("key", key), elem, writeConcern: WriteConcern.ACKNOWLEDGED);
              });
       } else { 
         keys.add(key);
         return Future.forEach(data,
                       (elem){
                         return _collection.insert(elem, writeConcern: WriteConcern.ACKNOWLEDGED);
                       });
       }
       dispatch(key, value);
       
    }
    
    void add(String key, data) {
      List list = new List(); 
      if (keys.contains(key)) {
        getItem(key).then((value) {
          if (value is List) {
              list = value;
                      
              _add(list, key, data);
          }
          });
       } else {
         _add(list, key, data);
       }
     }
    
    void _add(List list, String key, data) {
        list.add(data);
        
        setItem(key, list);
    }

    void removeItem(String key) {
      _collection.remove(where.eq("key", key));
      dispatch_removed(key);
    }

    void clear() {
      _collection.remove();
    }

    Future<int> length() {
      Completer completer = new Completer();
      
      _collection.find().toList().then((List<Map> list) {                
          completer.complete(list.length);
      });
      
      return completer.future;
    }
    
    Map exportSync() {
      throw new UnsupportedError('MongoDB implementation not ready to use this function!');
    }
     
    Future<Map> export() {
      Completer completer = new Completer<Map>();
      _collection.find().toList().then((List<Map> list) {
        Map values = new Map();
        var key, data;
        for (Map value in list) {
             key = value["key"];
             data = value["value"];
             values[key] = JSON.decode(data); 
        }
        completer.complete(values);
      });
      return completer.future;
    }

    Future start() {
      _db = new Db(this.address);
      _collection = _db.collection(this.collection);
      
      _db.open().then((event) {
        // TODO: retrieve all keys
        _collection.find().toList().then((List<Map> list) {
          for (Map value in list) {
            keys.add(value["key"]);
          }
          
          _completer.complete();
        });
        
      });
      return _completer.future;
    }
}