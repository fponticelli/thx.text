package thx.text.table;

abstract CellValue(CellValueImpl) from CellValueImpl to CellValueImpl {
  @:from inline public static function fromInt(v : Int) : CellValue
    return IntCell(v);

  @:from inline public static function fromFloat(v : Float) : CellValue
    return FloatCell(v);

  @:from inline public static function fromString(v : String) : CellValue
    return StringCell(v);

  @:from inline public static function fromBool(v : Bool) : CellValue
    return BoolCell(v);

  @:from inline public static function fromDate(v : Date) : CellValue
    return DateTimeCell(v);

  @:from inline public static function fromDateTime(v : DateTime) : CellValue
    return DateTimeCell(v);

  @:from inline public static function fromTime(v : Time) : CellValue
    return TimeCell(v);

  inline public static function empty() : CellValue
    return Empty;

  inline public static function na() : CellValue
    return NA;
}

enum CellValueImpl {
  IntCell(v : Int);
  FloatCell(v : Float); // can be Infinity or NaN
  StringCell(v : String); // can be null
  BoolCell(v : Bool);
  DateTimeCell(v : DateTime);
  TimeCell(v : Time);
  Empty;
  NA;
}
