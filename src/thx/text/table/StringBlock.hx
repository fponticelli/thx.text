package thx.text.table;

import haxe.Utf8;
using thx.Arrays;
using thx.Ints;
using thx.Strings;

class StringBlock {
  public static function fromString(s : String) : StringBlock {
    var lines = (~/(\r\n|\n\r|\n|\r)/g).split(s);
    return new StringBlock(lines);
  }

  public static function empty() : StringBlock {
    return new StringBlock([]);
  }

  var lines : Array<String>;
  public var width : Int;
  public var height : Int;

  public function new(lines : Array<String>) {
    this.lines = lines;
    this.width = lines.reduce(function(width : Int, line) return width.max(Utf8.length(line)), 0);
    this.height = lines.length;
  }

  public function getLine(index : Int) {
    if(index >= height)
      return [];
    return lines[index].toArray();
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
  public function toString() {
    return lines.join("\n");
  }
}
