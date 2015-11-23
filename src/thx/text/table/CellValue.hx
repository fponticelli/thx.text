package thx.text.table;

import thx.Types;
import thx.Floats;
import thx.Ints;
import thx.Bools;
import thx.DateTime;
import thx.Time;

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

  public static function fromDynamic(value : Dynamic) : CellValue {
    if(null == value)
      return Empty;
    return switch Types.valueTypeToString(value) {
      case "String": parseString(value);
      case "Bool": BoolCell(value);
      case "Int": IntCell(value);
      case "Float": FloatCell(value);
      case "Date": DateTimeCell((value : Date));
      case _: StringCell(Std.string(value));
    };
  }

  public static function parseString(value : String) : CellValue {
    if(null == value)
      return Empty;
    return switch value.toLowerCase() {
      case "true", "t", "on", "✓", "✔":
        BoolCell(true);
      case "false", "f", "off", "✕", "✗":
        BoolCell(false);
      case i if(Ints.canParse(i)):
        IntCell(Ints.parse(i));
      case f if(Floats.canParse(f)):
        FloatCell(Ints.parse(f));
      case _:
        try DateTimeCell(DateTime.fromString(value)) catch(_ : Dynamic)
        try TimeCell(Time.fromString(value)) catch(_ : Dynamic)
            StringCell(value);
    }
  }

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
