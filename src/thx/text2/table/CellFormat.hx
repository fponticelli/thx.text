package thx.text.table;

class CellFormat<T> {
  var format : T -> String;
  var postFormat : String -> String;
  public function new(format : T -> String, ?postFormat : String -> String) {
    this.format = format;
    this.postFormat = null == postFormat ? function(s) return s : postFormat;
  }
}

/*
var table = new Table();
table.headerColumns(1);
table.headerRows(1);
table.addIndex();
table.setCellFormat(col, row, Table.float);
table.setColumnFormat(col, Table.bool);

table.header([...]);
table.row([...]);
table.format([
  ["name",  "age", "income",  "is person"],
  ["franco",  43,   100.123,   true],
  ["thx",      6,   999.99,    false],
  ["haxe",  null,  1000,       false]
]);

// TODO
//  * support vertical align
//  * fixed width

*/
