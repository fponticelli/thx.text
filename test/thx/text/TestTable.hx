package thx.text;

import utest.Assert;
using thx.text.Table;

class TestTable {
  public function new() { }

  public function testTableSize() {
    var table = new Table();
    table.set(Cell.empty(), 3, 2);
    Assert.equals(4, table.rows);
    Assert.equals(3, table.cols);
    table.set(Cell.empty(Span(2, 3)), 4, 3);
    Assert.equals(6, table.rows);
    Assert.equals(6, table.cols);
  }

  public function testToString() {
    var table = new Table();
    table.set(Cell.string("X"), 0, 0);
    table.set(Cell.int(1), 1, 1);
    table.set(Cell.float(0.1), 2, 2);
    trace("\n"+table.toString());
  }
}
