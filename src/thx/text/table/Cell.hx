package thx.text.table;

class Cell {
  var row : Row;
  var col : Column;
  public function new(row : Row, col : Column) {
    this.row = row;
    this.col = col;
  }
}
