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

    var cells = table.toArray()
                  .order(function(a, b) return Enums.compare(b.span, a.span)),
        blocks = cells.map(function(cell) {
          var maxWidth  = cell.style.maxWidth,
              maxHeight = cell.style.maxHeight,
              minWidth  = cell.style.minWidth,
              minHeight = cell.style.minHeight,
              spanRight = 1,
              spanDown = 1;

          switch cell.span {
            case SpanRight(c), SpanBoth(_, c) if(c > 1):
              spanRight = c;
            case FillRight, FillBoth:
              spanRight = cell.table.cols - cell.col.index;
            case _:
          }

          switch cell.span {
            case SpanDown(r), SpanBoth(r, _) if(r > 1):
              spanDown = r;
            case FillDown, FillBoth:
              spanDown = cell.table.rows - cell.row.index;
            case _:
          }

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
              if(spanRight == 1)
                colWidths[cell.col.index] = colWidths[cell.col.index].max(width + extra);
            case _:
              if(spanRight == 1)
                colWidths[cell.col.index] = colWidths[cell.col.index].max(width);
          }
          rowHeights[cell.row.index] = rowHeights[cell.row.index].max(height);

          return {
            block : block,
            cell : cell,
            halign : halign,
            spanRight : spanRight,
            spanDown : spanDown
          };
        });
    // resize canvas
    var width = colWidths.reduce(reduceWidth, 1),
        height = rowHeights.reduce(reduceHeight, 1);

    canvas.expand(width, height);

    blocks.each(function(item) {
      // get x, y
      var x = colWidths.slice(0, item.cell.col.index).reduce(reduceWidth, 0),
          y = rowHeights.slice(0, item.cell.row.index).reduce(reduceHeight, 0),
          width = [for(i in 0...item.spanRight) colWidths[item.cell.col.index + i] + (i > 0 ? 2 * padding + 1 : 0)].sum(),
          height = [for(i in 0...item.spanDown) rowHeights[item.cell.row.index + i] + (i > 0 ? 1 : 0)].sum();

      // paint content
      canvas.paintBlock(item.block, x + 1 + padding, y + 1, width, 1, item.halign, symbolPos[item.cell.col.index]);

      // paint borders
      var w = width + (1 + padding) * 2,
          h = height + 2;
      canvas.paintBorder(item.cell.style.type, x, y, w, h);
    });
    // paint table bottom line
    canvas.paintBottomLine(Body, 0, height-1, width);
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
