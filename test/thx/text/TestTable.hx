package thx.text;

import utest.Assert;
using thx.text.Table;

class TestTable {
  public function new() { }

  var table : Table;
  public function setup() {
    table = new Table();
  }

  public function testTableSize() {
    Assert.equals(0, table.rows);
    Assert.equals(0, table.cols);
    table.getCol(2);
    Assert.equals(0, table.cols);
    table.ensureCol(3);
    Assert.equals(4, table.cols);
    Assert.equals(0, table.rows);
    table.ensureRow(1);
    Assert.equals(2, table.rows);
  }

  public function testCellResizeTable() {
    table.set(IntCell(1), 3, 2);
    Assert.equals(3, table.cols);
    Assert.equals(4, table.rows);
  }

  public function testIdentityOfReferrableEntities() {
    var cell = table.set(IntCell(1), 3, 2);
    Assert.isTrue(cell == table.get(3, 2));

    Assert.isTrue(cell == table.getRow(3).get(2));
    Assert.isTrue(cell == table.getCol(2).get(3));

    Assert.isTrue(cell.row == table.getRow(3));
    Assert.isTrue(cell.col == table.getCol(2));

    Assert.isTrue(cell.table == table);
    Assert.isTrue(cell.row.table == table);
    Assert.isTrue(cell.col.table == table);
  }
/*
  public function testTableSize() {
    var table = new Table();
    table.set(Cell.empty(), 3, 2);
    Assert.equals(4, table.rows);
    Assert.equals(3, table.cols);
    table.set(Cell.empty(SpanBoth(2, 3)), 4, 3);
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

  public function testSimpleSpanning() {
    var table = new Table();
    table.set(Cell.string("0/0"), 0, 0);
    table.set(Cell.string("0/1"), 0, 1);
    table.set(Cell.string("1/0", SpanHorizontal(2)), 1, 0);

    trace("\n"+table.toString());

    table = new Table();
    table.set(Cell.string("0/0"), 0, 0);
    table.set(Cell.string("0/1", SpanVertical(2)), 0, 1);
    table.set(Cell.string("1/0"), 1, 0);

    trace("\n"+table.toString());
  }

  public function testSpanning() {
    var table = new Table();
    table.set(Cell.string("0/0"), 0, 0);
    table.set(Cell.string("0/1", SpanBoth(2, 2)), 0, 1);
    table.set(Cell.string("0/2", SpanVertical(2)), 0, 2);
    table.set(Cell.string("1/0"), 1, 0);
    table.set(Cell.string("2/0", SpanHorizontal(2)), 2, 0);
    table.set(Cell.string("2/2", SpanHorizontal(2)), 2, 2);
    trace("\n"+table.toString());
  }
*/
}
