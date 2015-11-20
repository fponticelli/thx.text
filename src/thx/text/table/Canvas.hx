package thx.text.table;

using thx.Arrays;
using thx.Enums;
using thx.Ints;
using thx.Effects;
import thx.text.table.Style;

class Canvas {
  public var width(default, null) : Int;
  public var height(default, null) : Int;
  var values : Array<Array<Symbol>>;
  public function new(width : Int, height : Int) {
    values = [];
    expand(width, height);
  }

  public function expand(width : Int, height : Int) {
    // add rows first if needed
    for(i in this.height...height) {
      values.push([for(j in 0...width) Empty]);
    }
    // patch previous rows to the right number of columns
    if(width > this.width) {
      for(i in 0...this.height) {
        var row = values[i];
        for(j in this.width...width) {
          row.push(Empty);
        }
      }
    }

    this.width = this.width.max(width);
    this.height = this.height.max(height);
  }

  public function get(x : Int, y : Int) : Null<Symbol> {
    var row = values[y];
    if(null == row)
      return null;
    return row[x];
  }

  public function set(x : Int, y : Int, symbol : Symbol) {
    values[y][x] = symbol;
  }

  public function setChar(x : Int, y : Int, char : String) {
    //expand(x+1, y+1); // TODO remove
    set(x, y, Char(char));
  }

  public function combine(x : Int, y : Int, symbol : Symbol) {
    //expand(x+1, y+1);
    values[y][x] = values[y][x].combine(symbol);
  }

  public function combineChar(x : Int, y : Int, char : String) {
    combine(x, y, Char(char));
  }

  public function paintBlock(block : StringBlock, x : Int, y : Int, width : Int, height : Int, halign : HAlign, symbolPos : Int) {
    for(i in 0...block.height) {
      var line = block.getLine(i),
          len = line.length;
      var hoffset = switch halign {
        case Left:
          0;
        case Right:
          width - len;
        case Center:
          Math.floor((width - len) / 2);
        case OnSymbol(s):
          var pos = line.lastIndexOf(s);
          if(pos < 0)
            width - (len + symbolPos);
          else if((len - pos) < symbolPos)
            width - len - (symbolPos - (len - pos));
          else
            width - len;
      };

      for(j in 0...len)
        setChar(x + hoffset + j, y + i, line[j]);
    }
  }

  public function paintBorder(type : CellType, x : Int, y : Int, w : Int, h : Int) {
    // topleft
    combine(x, y, pickTopLeft(type));
    // topright
    combine(x + w - 1, y, pickTopRight(type));
    // bottomleft
    combine(x, y + h - 1, pickBottomLeft(type));
    // bottomright
    combine(x + w - 1, y + h - 1, pickBottomRight(type));
    for(i in 1...w-1) {
      // top
      combine(x + i, y, pickTop(type));
      // bottom
      combine(x + i, y + h - 1, pickBottom(type));
    }
    for(i in 1...h-1) {
      // left
      combine(x, y + i, pickLeft(type));
      // right
      combine(x + w - 1, y + i, pickRight(type));
    }
  }

  public function paintBottomLine(type : CellType, x : Int, y : Int, w : Int) {
    combine(x, y, pickBottomLeft(type));
    combine(x + w - 1, y, pickBottomRight(type));
    for(i in 1...w-1) {
      combine(x + i, y, pickBottom(type));
    }
  }

  function typeToBorder(type : CellType) return switch type {
    case Header, HeaderCompact: Double;
    case _: Normal;
  };

  public function pickTopLeft(type : CellType) return Border(switch type {
    case Header, Body: Cross(None, typeToBorder(type), typeToBorder(type), None);
    case HeaderCompact: Removable;
    case BodyCompact: RemovableCross(None, None, typeToBorder(type), None);
  });

  public function pickTopRight(type : CellType) return Border(switch type {
    case Header, Body: Cross(None, None, typeToBorder(type), typeToBorder(type));
    case HeaderCompact: Removable;
    case BodyCompact: RemovableCross(None, None, typeToBorder(type), None);
  });

  public function pickBottomLeft(type : CellType) return Border(switch type {
    case Header, Body: Cross(typeToBorder(type), typeToBorder(type), None, None);
    case HeaderCompact: Cross(None, typeToBorder(type), None, None);
    case BodyCompact: RemovableCross(typeToBorder(type), None, None, None);
  });

  public function pickBottomRight(type : CellType) return Border(switch type {
    case Header, Body: Cross(typeToBorder(type), None, None, typeToBorder(type));
    case HeaderCompact: Cross(None, None, None, typeToBorder(type));
    case BodyCompact: RemovableCross(typeToBorder(type), None, None, None);
  });

  public function pickTop(type : CellType) return Border(switch type {
    case Header, Body: Cross(None, typeToBorder(type), None, typeToBorder(type));
    case HeaderCompact, BodyCompact: Removable;
  });

  public function pickBottom(type : CellType) return Border(switch type {
    case Header, Body, HeaderCompact: Cross(None, typeToBorder(type), None, typeToBorder(type));
    case BodyCompact: Removable;
  });

  public function pickLeft(type : CellType) return Border(switch type {
    case Header, Body, BodyCompact: Cross(typeToBorder(type), None, typeToBorder(type), None);
    case HeaderCompact: Removable;
  });

  public function pickRight(type : CellType) return Border(switch type {
    case Header, Body, BodyCompact: Cross(typeToBorder(type), None, typeToBorder(type), None);
    case HeaderCompact: Removable;
  });

  public function render(symbol : Symbol)
    return switch symbol {
      case Char(c): c;
      // empty
      case Empty, Border(Removable),
           Border(Cross(None, None, None, None)),
           Border(RemovableCross(None, None, None, None)): " ";

      // one
      case Border(Cross(Double, None, None, None)),
           Border(RemovableCross(Double, None, None, None)): "╹";
      case Border(Cross(Normal, None, None, None)),
           Border(RemovableCross(Normal, None, None, None)): "╵";
      case Border(Cross(None, Double, None, None)),
           Border(RemovableCross(None, Double, None, None)): "╺";
      case Border(Cross(None, Normal, None, None)),
           Border(RemovableCross(None, Normal, None, None)): "╶";
      case Border(Cross(None, None, Double, None)),
           Border(RemovableCross(None, None, Double, None)): "╻";
      case Border(Cross(None, None, Normal, None)),
           Border(RemovableCross(None, None, Normal, None)): "╷";
      case Border(Cross(None, None, None, Double)),
           Border(RemovableCross(None, None, None, Double)): "╸";
      case Border(Cross(None, None, None, Normal)),
           Border(RemovableCross(None, None, None, Normal)): "╴";

      // two A
      case Border(Cross(None, None, Double, Double)),
           Border(RemovableCross(None, None, Double, Double)): "┓";
      case Border(Cross(None, None, Normal, Normal)),
           Border(RemovableCross(None, None, Normal, Normal)): "┐";
      case Border(Cross(None, Double, None, Double)),
           Border(RemovableCross(None, Double, None, Double)): "━";
      case Border(Cross(None, Normal, None, Normal)),
           Border(RemovableCross(None, Normal, None, Normal)): "─";
      case Border(Cross(None, Double, Double, None)),
           Border(RemovableCross(None, Double, Double, None)): "┏";
      case Border(Cross(None, Normal, Normal, None)),
           Border(RemovableCross(None, Normal, Normal, None)): "┌";
      case Border(Cross(Double, None, Double, None)),
           Border(RemovableCross(Double, None, Double, None)): "┃";
      case Border(Cross(Normal, None, Normal, None)),
           Border(RemovableCross(Normal, None, Normal, None)): "│";
      case Border(Cross(Double, None, None, Double)),
           Border(RemovableCross(Double, None, None, Double)): "┛";
      case Border(Cross(Normal, None, None, Normal)),
           Border(RemovableCross(Normal, None, None, Normal)): "┘";
      case Border(Cross(Double, Double, None, None)),
           Border(RemovableCross(Double, Double, None, None)): "┗";
      case Border(Cross(Normal, Normal, None, None)),
           Border(RemovableCross(Normal, Normal, None, None)): "└";

      // two A+B
      case Border(Cross(None, None, Double, Normal)),
           Border(RemovableCross(None, None, Double, Normal)): "┒";
      case Border(Cross(None, None, Normal, Double)),
           Border(RemovableCross(None, None, Normal, Double)): "┑";
      case Border(Cross(None, Double, None, Normal)),
           Border(RemovableCross(None, Double, None, Normal)): "╼";
      case Border(Cross(None, Normal, None, Double)),
           Border(RemovableCross(None, Normal, None, Double)): "╾";
      case Border(Cross(None, Double, Normal, None)),
           Border(RemovableCross(None, Double, Normal, None)): "┍";
      case Border(Cross(None, Normal, Double, None)),
           Border(RemovableCross(None, Normal, Double, None)): "┎";
      case Border(Cross(Double, None, Normal, None)),
           Border(RemovableCross(Double, None, Normal, None)): "╿";
      case Border(Cross(Normal, None, Double, None)),
           Border(RemovableCross(Normal, None, Double, None)): "╽";
      case Border(Cross(Double, None, None, Normal)),
           Border(RemovableCross(Double, None, None, Normal)): "┚";
      case Border(Cross(Normal, None, None, Double)),
           Border(RemovableCross(Normal, None, None, Double)): "┙";
      case Border(Cross(Double, Normal, None, None)),
           Border(RemovableCross(Double, Normal, None, None)): "┖";
      case Border(Cross(Normal, Double, None, None)),
           Border(RemovableCross(Normal, Double, None, None)): "┕";

      // three A
      case Border(Cross(None, Double, Double, Double)),
           Border(RemovableCross(None, Double, Double, Double)): "┳";
      case Border(Cross(None, Normal, Normal, Normal)),
           Border(RemovableCross(None, Normal, Normal, Normal)): "┬";
      case Border(Cross(Double, None, Double, Double)),
           Border(RemovableCross(Double, None, Double, Double)): "┫";
      case Border(Cross(Normal, None, Normal, Normal)),
           Border(RemovableCross(Normal, None, Normal, Normal)): "┤";
      case Border(Cross(Double, Double, None, Double)),
           Border(RemovableCross(Double, Double, None, Double)): "┻";
      case Border(Cross(Normal, Normal, None, Normal)),
           Border(RemovableCross(Normal, Normal, None, Normal)): "┴";
      case Border(Cross(Double, Double, Double, None)),
           Border(RemovableCross(Double, Double, Double, None)): "┣";
      case Border(Cross(Normal, Normal, Normal, None)),
           Border(RemovableCross(Normal, Normal, Normal, None)): "├";

      // three A + B
      case Border(Cross(None, Double, Normal, Normal)),
           Border(RemovableCross(None, Double, Normal, Normal)): "┮";
      case Border(Cross(None, Normal, Double, Normal)),
           Border(RemovableCross(None, Normal, Double, Normal)): "┰";
      case Border(Cross(None, Normal, Normal, Double)),
           Border(RemovableCross(None, Normal, Normal, Double)): "┭";
      case Border(Cross(None, Double, Double, Normal)),
           Border(RemovableCross(None, Double, Double, Normal)): "┲";
      case Border(Cross(None, Double, Normal, Double)),
           Border(RemovableCross(None, Double, Normal, Double)): "┯";
      case Border(Cross(None, Normal, Double, Double)),
           Border(RemovableCross(None, Normal, Double, Double)): "┱";

      case Border(Cross(Double, None, Normal, Normal)),
           Border(RemovableCross(Double, None, Normal, Normal)): "┦";
      case Border(Cross(Normal, None, Double, Normal)),
           Border(RemovableCross(Normal, None, Double, Normal)): "┧";
      case Border(Cross(Normal, None, Normal, Double)),
           Border(RemovableCross(Normal, None, Normal, Double)): "┥";
      case Border(Cross(Double, None, Double, Normal)),
           Border(RemovableCross(Double, None, Double, Normal)): "┨";
      case Border(Cross(Double, None, Normal, Double)),
           Border(RemovableCross(Double, None, Normal, Double)): "┩";
      case Border(Cross(Normal, None, Double, Double)),
           Border(RemovableCross(Normal, None, Double, Double)): "┪";

      case Border(Cross(Double, Normal, None, Normal)),
           Border(RemovableCross(Double, Normal, None, Normal)): "┸";
      case Border(Cross(Normal, Double, None, Normal)),
           Border(RemovableCross(Normal, Double, None, Normal)): "┶";
      case Border(Cross(Normal, Normal, None, Double)),
           Border(RemovableCross(Normal, Normal, None, Double)): "┵";
      case Border(Cross(Double, Double, None, Normal)),
           Border(RemovableCross(Double, Double, None, Normal)): "┺";
      case Border(Cross(Double, Normal, None, Double)),
           Border(RemovableCross(Double, Normal, None, Double)): "┹";
      case Border(Cross(Normal, Double, None, Double)),
           Border(RemovableCross(Normal, Double, None, Double)): "┷";

      case Border(Cross(Double, Normal, Normal, None)),
           Border(RemovableCross(Double, Normal, Normal, None)): "┞";
      case Border(Cross(Normal, Double, Normal, None)),
           Border(RemovableCross(Normal, Double, Normal, None)): "┝";
      case Border(Cross(Normal, Normal, Double, None)),
           Border(RemovableCross(Normal, Normal, Double, None)): "┟";
      case Border(Cross(Double, Double, Normal, None)),
           Border(RemovableCross(Double, Double, Normal, None)): "┡";
      case Border(Cross(Double, Normal, Double, None)),
           Border(RemovableCross(Double, Normal, Double, None)): "┠";
      case Border(Cross(Normal, Double, Double, None)),
           Border(RemovableCross(Normal, Double, Double, None)): "┢";

      // four A
      case Border(Cross(Double, Double, Double, Double)),
           Border(RemovableCross(Double, Double, Double, Double)): "╋";
      case Border(Cross(Normal, Normal, Normal, Normal)),
           Border(RemovableCross(Normal, Normal, Normal, Normal)): "┼";

      // four A + B
      case Border(Cross(Double, Normal, Normal, Normal)),
           Border(RemovableCross(Double, Normal, Normal, Normal)): "╀";
      case Border(Cross(Normal, Double, Normal, Normal)),
           Border(RemovableCross(Normal, Double, Normal, Normal)): "┾";
      case Border(Cross(Normal, Normal, Double, Normal)),
           Border(RemovableCross(Normal, Normal, Double, Normal)): "╁";
      case Border(Cross(Normal, Normal, Normal, Double)),
           Border(RemovableCross(Normal, Normal, Normal, Double)): "┽";

      case Border(Cross(Double, Double, Normal, Normal)),
           Border(RemovableCross(Double, Double, Normal, Normal)): "╄";
      case Border(Cross(Double, Normal, Double, Normal)),
           Border(RemovableCross(Double, Normal, Double, Normal)): "╂";
      case Border(Cross(Double, Normal, Normal, Double)),
           Border(RemovableCross(Double, Normal, Normal, Double)): "╃";
      case Border(Cross(Normal, Double, Double, Normal)),
           Border(RemovableCross(Normal, Double, Double, Normal)): "╆";
      case Border(Cross(Normal, Normal, Double, Double)),
           Border(RemovableCross(Normal, Normal, Double, Double)): "╅";
      case Border(Cross(Normal, Double, Normal, Double)),
           Border(RemovableCross(Normal, Double, Normal, Double)): "┿";

      case Border(Cross(Double, Double, Double, Normal)),
           Border(RemovableCross(Double, Double, Double, Normal)): "╊";
      case Border(Cross(Double, Double, Normal, Double)),
           Border(RemovableCross(Double, Double, Normal, Double)): "╇";
      case Border(Cross(Double, Normal, Double, Double)),
           Border(RemovableCross(Double, Normal, Double, Double)): "╉";
      case Border(Cross(Normal, Double, Double, Double)),
           Border(RemovableCross(Normal, Double, Double, Double)): "╈";
    };

  public function toString() {
    return values
      .filter(function(row) {
        return !row.all(function(symbol) {
          return switch symbol {
            case Border(Removable), Border(RemovableCross(_)): true;
            case _: false;
          };
        });
      })
      .map(function(row) {
        return row.reduce(function(buff, symbol) {
          return buff + render(symbol);
        }, "");
      }).join("\n");
  }
}

abstract Symbol(SymbolImpl) from SymbolImpl to SymbolImpl {
  public function combine(that : Symbol) : Symbol {
    if(null == this) return that;
    if(null == that) return this;
    return switch [this, that] {
      case [Border(b1), Border(b2)]:
        Border(mergeBorders(b1, b2));
      case [Empty, _]: that;
      case [_, Empty]: this;
      case [_, _]: that; // TODO don't override?
    };
  }

  public static function mergeBorders(b1 : Border, b2 : Border) return switch [b1, b2] {
    case [RemovableCross(_), Removable]: b1;
    case [Removable, RemovableCross(_)]: b2;
    case [Removable, Removable]: b1;
    case [Removable, Cross(_)]: b2;
    case [Cross(_), Removable]: b1;
    case [Cross(t1, r1, b1, l1), Cross(t2, r2, b2, l2)],
         [RemovableCross(t1, r1, b1, l1), Cross(t2, r2, b2, l2)],
         [Cross(t1, r1, b1, l1), RemovableCross(t2, r2, b2, l2)]:
    Cross(t1.max(t2), r1.max(r2), b1.max(b2), l1.max(l2));
    case [RemovableCross(t1, r1, b1, l1), RemovableCross(t2, r2, b2, l2)]:
      RemovableCross(t1.max(t2), r1.max(r2), b1.max(b2), l1.max(l2));
  };
}

enum SymbolImpl {
  Empty;
  Char(s : String);
  Border(b : Border);
}
