package thx.text;

import thx.ReadonlyArray;
import thx.text.table.*;
import thx.text.table.Style;

class Table {
  public var rows(get, set) : Int;
  public var cols(get, set) : Int;
  public var style(default, null) : IStyle;

  var _rows : Array<Row>;
  var _cols : Array<Col>;

  public function new() {
    _rows = [];
    _cols = [];
    style = new Style();
  }

  @:access(thx.text.table.Col.setCell)
  public function set(value : CellValue, row : Int, col : Int, ?span : Span) {
    if(null == span)
      span = NoSpan;
    var r = ensureRow(row),
        c = ensureCol(col),
        cell = new Cell(value, r, c, span);
    c.setCell(row, cell);
    return cell;
  }

  public function get(row : Int, col : Int) : Null<Cell> {
    var col = getCol(col);
    if(null == col) return null;
    return col.get(row);
  }

  public function ensureCol(index : Int) : Col {
    for(i in _cols.length...index+1)
      _cols[i] = new Col(this, i);
    return _cols[index];
  }

  public function ensureRow(index : Int) : Row {
    for(i in _rows.length...index+1)
      _rows[i] = new Row(this, i);
    return _rows[index];
  }

  public function getCol(index : Int) : Null<Col>
    return _cols[index];

  public function getRow(index : Int) : Null<Row>
    return _rows[index];

  public function toArray() : Array<Cell> {
    var collector = [];
    for(row in _rows)
      for(cell in row)
        collector.push(cell);
    return collector;
  }

  public function toString() {
    var renderer = new Renderer();
    return renderer.render(this);
  }

  function get_rows()
    return _rows.length;

  function get_cols()
    return _cols.length;

  function set_rows(value : Int) {
    ensureRow(value + 1);
    return value;
  }

  function set_cols(value : Int) {
    ensureCol(value + 1);
    return value;
  }
}
