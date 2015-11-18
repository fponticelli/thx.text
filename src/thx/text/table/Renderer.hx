package thx.text.table;

import thx.text.Table;
using thx.Arrays;
using thx.Enums;
using thx.Ints;
using thx.Nulls;

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
    canvas = new Canvas(0, 0);
    processContents();
    return canvas.toString();
  }

  function processContents() {
    colWidths = [for(i in 0...table.cols) 0];
    rowHeights = [for(i in 0...table.rows) 0];
    var cells = table.toArray().order(function(a, b) return Enums.compare(b.style.border, a.style.border)),
        blocks = cells.map(function(cell) {
          var maxWidth = cell.style.maxWidth,
              maxHeight = cell.style.maxHeight; // TODO account for padding

          var block = cell.style.formatter(cell.value, maxWidth),
              width = maxWidth == null ? block.width : maxWidth.min(block.width),
              height = maxHeight == null ? block.height : maxHeight.min(block.height);

          colWidths[cell.col.index] = colWidths[cell.col.index].max(width);
          rowHeights[cell.row.index] = rowHeights[cell.row.index].max(height);

          return {
            block : block,
            cell : cell
          }
        });
    // resize canvas
    var width = colWidths.reduce(reduceWidth, 1),
        height = rowHeights.reduce(reduceHeight, 1);

    canvas.expand(width, height);

    blocks.each(function(item) {
      // get x, y
      var x = colWidths.slice(0, item.cell.col.index).reduce(reduceWidth, 1 + padding),
          y = rowHeights.slice(0, item.cell.row.index).reduce(reduceHeight, 1);
      // trace(item.block.toString());
      // trace(item.cell.col.index, item.cell.row.index);
      // trace(x, y);

      // paint content
      // TODO
      // * consider max height and height
      // * consider valign
      // * consider halign
      canvas.paintBlock(item.block, x, y);

      // paing borders
    });
  }

  function reduceWidth(acc : Int, width : Int) {
    return  acc + width + padding * 2 + 1 /* border */;
  }

  function reduceHeight(acc : Int, height : Int) {
    return  acc + height + 1 /* border */;
  }
}

typedef CellRender = {
  cell : Cell,
  block : StringBlock
}
