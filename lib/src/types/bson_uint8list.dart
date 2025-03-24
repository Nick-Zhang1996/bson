import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

//import '../utils/statics.dart';
//import '../utils/types_def.dart';
import 'base/bson_object.dart';
import 'bson_binary.dart';

class BsonUint8List extends BsonObject {
  BsonUint8List(this.data)
      : _totalByteLength = data.length + 8; // data and 64bit length value
  BsonUint8List.fromBuffer(BsonBinary buffer)
      : data = extractData(buffer),
        _totalByteLength = buffer.totalByteLength + 8;
  BsonUint8List.fromEJson(Map<String, dynamic> eJsonMap)
      : data = Uint8List(0),
        _totalByteLength = 0 {
    throw Exception('unimplemented');
  }

  static double extractEJson(Map<String, dynamic> eJsonMap) {
    throw Exception('unimplemented');
  }

  Uint8List data;
  final int _totalByteLength;

  static Uint8List extractData(BsonBinary buffer) => buffer.readUint8List();

  @override
  Uint8List get value => data;
  @override
  int get totalByteLength => _totalByteLength;
  @override
  int get typeByte => bsonUint8List;
  @override
  void packValue(BsonBinary buffer) {
    /// first 8 bytes specify length as int64, rest are data
    assert(data.length == data.lengthInBytes);
    buffer.writeFixInt64(Int64(data.length));
    // TODO we should use setRange for efficiency
    for (final val in data) {
      buffer.writeByte(val);
    }
  }

  @override
  eJson({bool relaxed = false}) {}
}
