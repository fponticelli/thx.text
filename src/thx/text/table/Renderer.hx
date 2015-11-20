package thx.text.table;

import thx.text.Table;
using thx.Arrays;
using thx.Enums;
using thx.Ints;
using thx.Nulls;

/*
TODO
  ? colspan
  ? rowspan
  ? fill right
  ? fill down
  ? fill
  ? valign
    ? top
    ? middle
    ? bottom
  ? maxheight
    ? crop
  ? maxwidth
    ? crop
  ? helper methods
*/

class Renderer {
  var padding : Int;
  var canvas : Canvas;
  var colWidths : Array<Int>;
  var rowHeights : Array<Int>;
  var symbolPos : Array<Int>;
  var table : Table;
  public function new(?padding : Int = 1) {
    this.padding = padding;
  }

  public function render(table : Table) : String {
    this.table = table;
    canvas = new Canvas(0, 0);
    processContents();
    return "\n" + canvas.toString();
  }

  function processContents() {
    colWidths = [for(i in 0...table.cols) 0];
    symbolPos = [for(i in 0...table.cols) 0];
    rowHeights = [for(i in 0...table.rows) 0];
    var cells = table.toArray().order(function(a, b) return Enums.compare(b.style.type, a.style.type)),
        blocks = cells.map(function(cell) {
          var maxWidth = cell.style.maxWidth,
              maxHeight = cell.style.maxHeight,
              minWidth = cell.style.minWidth,
              minHeight = cell.style.minHeight; // TODO account for padding

          var block = cell.style.formatter(cell.value, maxWidth),
              halign = cell.style.aligner(cell.value, cell.style.type),
              width = (maxWidth == null ? block.width : maxWidth.min(block.width)).max(minWidth),
              height = (maxHeight == null ? block.height : maxHeight.min(block.height)).max(minHeight);

          // find max pos of symbol aligner
          switch halign {
            case OnSymbol(s):
              var pos = block.symbolPos(s);
              symbolPos[cell.col.index] = symbolPos[cell.col.index].max(pos);
              var extra = symbolPos[cell.col.index] - pos;
              colWidths[cell.col.index] = colWidths[cell.col.index].max(width + extra);
            case _:
              colWidths[cell.col.index] = colWidths[cell.col.index].max(width);
          }
          rowHeights[cell.row.index] = rowHeights[cell.row.index].max(height);

          return {
            block : block,
            cell : cell,
            halign : halign
          }
        });
    // resize canvas
    var width = colWidths.reduce(reduceWidth, 1),
        height = rowHeights.reduce(reduceHeight, 1);

    canvas.expand(width, height);

    blocks.each(function(item) {
      // get x, y
      var x = colWidths.slice(0, item.cell.col.index).reduce(reduceWidth, 0),
          y = rowHeights.slice(0, item.cell.row.index).reduce(reduceHeight, 0),
          width = colWidths[item.cell.col.index];

      // TODO
      // * consider max height and height
      // * consider valign
      // * paint content
      canvas.paintBlock(item.block, x + 1 + padding, y + 1, width, item.halign, symbolPos[item.cell.col.index]);

      // paint borders
      var w = colWidths[item.cell.col.index] + (1 + padding) * 2,
          h = rowHeights[item.cell.row.index] + 2;
      canvas.paintBorder(item.cell.style.type, x, y, w, h);
    });
    //canvas.paintBorder(Body, 0, 0, width, height);
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

/*
public function getLine(line : Int, width : Int, halign : HAlign, valign : VAlign, totalLines : Int, symbolFromRight : Int) {
  var value = switch valign {
    case Top:
      lines[line];
    case Center:
      var mid = Math.floor(totalLines / 2);
      lines[line - (mid - lines.length)];
    case Bottom:
      lines[line - (totalLines - lines.length)];
  };

  if(null == value)
    value = "";
  return switch halign {
    case Left:
      value.rpad(" ", width);
    case Right:
      value.lpad(" ", width);
    case Center:
      var len = Utf8.length(value),
          space = width - len,
          left = Math.ceil(space / 2);
      value.lpad(" ", left + len).rpad(" ", width);
    case OnSymbol(symbol):
      var len = Utf8.length(value),
          pos = len - value.lastIndexOf(symbol);
      value.rpad(" ", len + symbolFromRight - pos).lpad(" ", width);
  };
}
*/
