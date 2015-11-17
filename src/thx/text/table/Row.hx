package thx.text.table;

class Row extends CellSet {
  function set(colIndex : Int, cell : Cell) {
    super._set(colIndex, cell);
    var col = table.ensureCol(colIndex);
    col._set(index, cell);
  }
}
