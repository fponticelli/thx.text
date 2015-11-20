package thx.text.table;

import thx.text.table.Style;

class Cell {
  public var value(default, null) : CellValue;
  public var row(default, null) : Row;
  public var col(default, null) : Col;
  public var rowIndex(get, null) : Int;
  public var colIndex(get, null) : Int;
  public var span(default, null) : Span;
  public var table(default, null) : Table;
  public var style(default, null) : IStyle;
  public function new(value : CellValue, row : Row, col : Col, span : Span) {
    this.value = value;
    this.row = row;
    this.col = col;
    this.span = span;
    this.table = col.table;
    this.style = new CompositeStyle([col.style, row.style, table.style, DefaultStyle.instance]);
  }

  public function toString() : String {
    var maxWidth = style.maxWidth;
    return style.formatter(value, maxWidth).toString();
  }

  function get_rowIndex()
    return row.index;

  function get_colIndex()
    return col.index;
}
