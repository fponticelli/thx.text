package thx.text.table;

import thx.text.table.Style;

class Cell {
  public var value(default, null) : CellValue;
  public var row(default, null) : Row;
  public var col(default, null) : Col;
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

  public function getWidth() {

  }
}
