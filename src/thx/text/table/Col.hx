package thx.text.table;

class Col extends CellSet {
  function setCell(rowIndex : Int, cell : Cell) {
    super._set(rowIndex, cell);
    var row = table.ensureRow(rowIndex);
    row._set(index, cell);
  }

  public function set(value : CellValue, row : Int, ?span : Span)
    return table.set(value, row, index, span);
}
