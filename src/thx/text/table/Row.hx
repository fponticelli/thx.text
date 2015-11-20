package thx.text.table;

class Row extends CellSet {
  function setCell(colIndex : Int, cell : Cell) {
    super._set(colIndex, cell);
    var col = table.ensureCol(colIndex);
    col._set(index, cell);
  }

  public function set(value : CellValue, col : Int, ?span : Span)
    return table.set(value, index, col, span);
}
