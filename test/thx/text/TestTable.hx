package thx.text;

import utest.Assert;
using thx.text.Table;
using thx.text.table.Canvas;
using thx.text.table.Renderer;
using thx.text.table.Style;
using thx.text.table.CellValue;

class TestTable {
  public function new() { }

  var table : Table;
  public function setup() {
    table = new Table();
  }

  public function testSpanRight() {
    table.style.type = Body;
    table.style.setAlign(Center);
    table.set(1, 0, 0, SpanRight(2));
    table.set(2, 1, 0);
    table.set(3, 1, 1);
    Assert.equals("
┌───────┐
│   1   │
├───┬───┤
│ 2 │ 3 │
└───┴───┘", table.toString());
  }

  public function testSpanDown() {
    table.style.type = Body;
    table.style.setAlign(Center);
    table.set(1, 0, 0, SpanDown(2));
    table.set(2, 0, 1);
    table.set(3, 1, 1);
    Assert.equals("
┌───┬───┐
│ 1 │ 2 │
│   ├───┤
│   │ 3 │
└───┴───┘", table.toString());
  }

  public function testSpanning() {
    table.style.type = Body;
    table.style.setAlign(Center);
    table.set("0/0", 0, 0);
    table.set("0/1", 0, 1, SpanBoth(2, 2));
    table.set("0/3", 0, 3, SpanDown(2));
    table.set("1/0", 1, 0);
    table.set("2/0", 2, 0, SpanRight(2));
    table.set("2/2", 2, 2, SpanRight(2));

    Assert.equals("
┌─────┬─────┬─────┐
│ 0/0 │ 0/1 │ 0/3 │
├─────┤     │     │
│ 1/0 │     │     │
├─────┴──┬──┴─────┤
│  2/0   │  2/2   │
└────────┴────────┘", table.toString());
  }

  public function testFromData() {
    var data : Array<Array<Dynamic>> = [
      ["rank", "country", "US $"],
      [1, "Luxembourg", 113533],
      [2, "Qatar", 98329],
      [3, "Norway", 97255],
      [4, "Switzerland", 81161],
      [5, "United Arab  Emirates", 67008],
      [6, "Australia", 65477],
      [7, "Denmark", 59928],
      [8, "Sweden", 56956],
      [9, "Canada", 50436],
      [10, "Netherlands", 50355]
    ];
    var table = Table.fromData(data, "average earnings");
    Assert.equals("
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃            average earnings            ┃
┣━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━┫
┃ rank ┃ country               ┃ US $    ┃
┡━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━┩
│    1 │ Luxembourg            │ 113,533 │
│    2 │ Qatar                 │  98,329 │
│    3 │ Norway                │  97,255 │
│    4 │ Switzerland           │  81,161 │
│    5 │ United Arab  Emirates │  67,008 │
│    6 │ Australia             │  65,477 │
│    7 │ Denmark               │  59,928 │
│    8 │ Sweden                │  56,956 │
│    9 │ Canada                │  50,436 │
│   10 │ Netherlands           │  50,355 │
└──────┴───────────────────────┴─────────┘", table.toString());
  }

  public function testFromObjects() {
    var data = [{
        code: "AD",
        latitude: 42.5,
        longitude: 1.6,
        name: "Andorra"
      }, {
        code: "AE",
        latitude: 23.4,
        longitude: 53.8,
        name: "United Arab Emirates"
      }, {
        code: "AF",
        latitude: 33.9,
        longitude: 67.7,
        name: "Afghanistan"
    }];
    var table = Table.fromObjects(data, "countries");
    Assert.equals("
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                     countries                      ┃
┣━━━━━━┳━━━━━━━━━━┳━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┫
┃ code ┃ latitude ┃ longitude ┃ name                 ┃
┡━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ AD   │     42.5 │       1.6 │ Andorra              │
│ AE   │     23.4 │      53.8 │ United Arab Emirates │
│ AF   │     33.9 │      67.7 │ Afghanistan          │
└──────┴──────────┴───────────┴──────────────────────┘", table.toString());
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
    Assert.equals("
┏━━━━━━━━━━━━┳━━━┳━━━━━┓
┃ Franco     ┃ ✓ ┃  ✕  ┃
┡━━━━━━━━━━━━╇━━━╇━━━━━┩
│ 11/19/2015 │   │ 200 │
└────────────┴───┴─────┘", s);
  }

  function oneCell(value : CellValue, width : Int) {
    table = new Table();
    table.style.type = Body;
    table.style.minWidth = width;
    table.set(value, 0, 0);
  }

  public function testAlign() {
    oneCell(0, 8);
    Assert.equals("
┌──────────┐
│        0 │
└──────────┘", table.toString());
    oneCell("0", 8);
    Assert.equals("
┌──────────┐
│ 0        │
└──────────┘", table.toString());
    oneCell(true, 8);
    Assert.equals("
┌──────────┐
│    ✓     │
└──────────┘", table.toString());
    oneCell(0.5, 8);
    Assert.equals("
┌──────────┐
│      0.5 │
└──────────┘", table.toString());
  }

  public function testAlignOnSymbol() {
    table.set(0.001, 0, 0);
    table.set(2.0,   0, 1);
    table.set(3333,  0, 2);
    table.set(12.5,  0, 3);
    table.style.type = Body;
    Assert.equals("
┌───────┬─────┬───────┬──────┐
│ 0.001 │ 2.0 │ 3,333 │ 12.5 │
└───────┴─────┴───────┴──────┘", table.toString());
  }

  public function testAlignOnSymbolVertical() {
    table.set(0.001, 0, 0);
    table.set(2.0,   1, 0);
    table.set(3333,  2, 0);
    table.set(12.5,  3, 0);
    table.style.type = Body;
    Assert.equals("
┌───────────┐
│     0.001 │
├───────────┤
│     2.0   │
├───────────┤
│ 3,333     │
├───────────┤
│    12.5   │
└───────────┘", table.toString());
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
}
