package thx.text.table;

using thx.Arrays;
using thx.Ints;

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
    expand(x+1, y+1);
    values[y][x] = symbol;
  }

  public function combine(x : Int, y : Int, symbol : Symbol) {
    expand(x+1, y+1);
    values[y][x] = values[y][x].combine(symbol);
  }

  public function render(symbol : Symbol)
    return switch symbol {
      case Empty: " ";
      case Char(c): c;
    };

  public function toString() {
    return values.map(function(row) {
      return row.reduce(function(buff, symbol) {
        return buff + render(symbol);
      }, "");
    }).join("\n");
  }
}

abstract Symbol(SymbolImpl) from SymbolImpl to SymbolImpl {
  public function combine(other : Symbol) : Symbol
    return switch [this, other] {
      case [Empty, _]: other;
      case [_, Char(_)]: other;
      case [_, Empty]: this;  // don't override?
    };
}

enum SymbolImpl {
  Empty;
  Char(s : String);
}
