package thx.text.table;

class CellFormat<T> {
  var format : T -> String;
  var postFormat : String -> String;
  public function new(format : T -> String, ?postFormat : String -> String) {
    this.format = format;
    this.postFormat = null == postFormat ? function(s) return s : postFormat;
  }
}
