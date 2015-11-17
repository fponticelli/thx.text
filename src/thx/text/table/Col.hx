package thx.text.table;

class Col extends CellSet {
  function set(rowIndex : Int, cell : Cell) {
    super._set(rowIndex, cell);
    var row = table.ensureRow(rowIndex);
    row._set(index, cell);
  }
}
