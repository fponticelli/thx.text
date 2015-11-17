package thx.text.table;

enum CellValue {
  IntCell(v : Int);
  FloatCell(v : Float); // can be Infinity or NaN
  StringCell(v : String); // can be null
  BoolCell(v : Bool);
  DateCell(v : Date);
  DateTimeCell(v : DateTime);
  TimeCell(v : Time);
  Empty;
  NA;
}
