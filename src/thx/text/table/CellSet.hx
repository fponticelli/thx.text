package thx.text.table;

using thx.Ints;
using thx.Maps;
import thx.text.table.Style;

class CellSet {
  var values : Map<Int, Cell>;
  public var size(default, null) : Int;
  public var table(default, null) : thx.text.Table;
  public var index(default, null) : Int;
  public var style(default, null) : IStyle;
  public function new(table : Table, index : Int) {
    this.index = index;
    this.table = table;
    values = new Map();
    size = 0;
    this.style = new Style();
  }

  public function get(index : Int)
    return values.get(index);

  public function iterator() : Iterator<Cell>
    return values.iterator();

  function _set(index : Int, cell : Cell) {
    size = index.max(size);
    values.set(index, cell);
  }
}
