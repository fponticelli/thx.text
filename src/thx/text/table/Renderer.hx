package thx.text.table;

import thx.text.Table;
using thx.Arrays;
using thx.Enums;

class Renderer {
  var padding : Int;
  var canvas : Canvas;
  var colWidths : Array<Int>;
  var rowHeights : Array<Int>;
  var table : Table;
  public function new(?padding : Int = 1) {
    this.padding = padding;
  }

  public function render(table : Table) : String {
    this.table = table;
    processContents();
    canvas = new Canvas(0, 0);
    return canvas.toString();
  }

  function renderCell(cell : Cell) {

  }

  function processContents() {
    colWidths = [];
    rowHeights = [];
    var cells = table.toArray().order(function(a, b) return Enums.compare(b.style.border, a.style.border));
    trace(cells);
  }
}

typedef CellRender = {
  cell : Cell,
  block : StringBlock
}
