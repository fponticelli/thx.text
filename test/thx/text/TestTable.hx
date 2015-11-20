package thx.text;

import utest.Assert;
using thx.text.Table;
using thx.text.table.Canvas;
using thx.text.table.Renderer;
using thx.text.table.Style;

class TestTable {
  public function new() { }

  var table : Table;
  public function setup() {
    table = new Table();
  }

  public function testPaintBorder() {
    var canvas = new Canvas(3, 3);
    canvas.paintBorder(Body, 0, 0, 3, 3);
    Assert.equals('┌─┐\n│ │\n└─┘', canvas.toString());

    canvas = new Canvas(4, 4);
    canvas.paintBorder(Body, 1, 0, 3, 3);
    Assert.equals(' ┌─┐\n │ │\n └─┘\n    ', canvas.toString());

    canvas = new Canvas(4, 4);
    canvas.paintBorder(Body, 1, 1, 3, 3);
    Assert.equals('    \n ┌─┐\n │ │\n └─┘', canvas.toString());
  }

  public function testRender() {
    var renderer = new Renderer();
    table.set(true, 0, 1);
    table.set("Franco", 0, 0);
    table.set(false, 0, 2);
    table.set(Date.fromString("2015-11-19"), 1, 0);
    table.set(200, 1, 2);
    table.style.type = Body;
    table.getRow(0).style.type = Header;
    var s = renderer.render(table);
    trace('$s');
    Assert.equals("
┏━━━━━━━━━━━━┳━━━┳━━━━━┓
┃ Franco     ┃ ✓ ┃ ✕   ┃
┡━━━━━━━━━━━━╇━━━╇━━━━━┩
│ 11/19/2015 │   │ 200 │
└────────────┘   └─────┘", s);
  }

  public function testSequence() {
    var last = table.set(true, 0, 1);
    var first = table.set(false, 0, 0);
    Assert.equals(1, last.col.index);
    Assert.equals(0, first.col.index);
  }

  public function testStyle() {
    var style = new Style();
    Assert.isNull(style.formatter);
    var dstyle = new DefaultStyle();
    Assert.notNull(dstyle.formatter);
    var cstyle = new CompositeStyle([style]);
    Assert.isNull(cstyle.formatter);
    cstyle = new CompositeStyle([style, dstyle]);
    Assert.notNull(cstyle.formatter);
  }

  public function testCanvas() {
    var canvas = new thx.text.table.Canvas(3, 2);
    Assert.equals("   \n   ", canvas.toString());
    canvas.expand(4, 3);
    Assert.equals("    \n    \n    ", canvas.toString());
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
    table.set(1, 3, 2);
    Assert.equals(3, table.cols);
    Assert.equals(4, table.rows);
  }

  public function testIdentityOfCellsCreatedFromTable() {
    var cell = table.set(1, 3, 2);
    Assert.isTrue(cell == table.get(3, 2));

    Assert.isTrue(cell == table.getRow(3).get(2));
    Assert.isTrue(cell == table.getCol(2).get(3));

    Assert.isTrue(cell.row == table.getRow(3));
    Assert.isTrue(cell.col == table.getCol(2));

    Assert.isTrue(cell.table == table);
    Assert.isTrue(cell.row.table == table);
    Assert.isTrue(cell.col.table == table);
  }

  public function testIdentityOfCellsCreatedFromRow() {
    var row = table.ensureRow(3),
        cell = row.set(1, 2);
    Assert.isTrue(cell == table.get(3, 2));

    Assert.isTrue(cell == table.getRow(3).get(2));
    Assert.isTrue(cell == table.getCol(2).get(3));

    Assert.isTrue(cell.row == table.getRow(3));
    Assert.isTrue(cell.col == table.getCol(2));

    Assert.isTrue(cell.table == table);
    Assert.isTrue(cell.row.table == table);
    Assert.isTrue(cell.col.table == table);
  }

  public function testIdentityOfCellsCreatedFromCol() {
    var col = table.ensureCol(2),
        cell = col.set(1, 3);
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
