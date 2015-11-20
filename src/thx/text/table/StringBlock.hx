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

  public function symbolPos(s : String) {
    var max = 0,
        pos;
    for(line in lines) {
      pos = line.lastIndexOf(s);
      if(pos <= 0)
        continue;
      max = max.max(line.length - pos);
    }
    return max;
  }

  public function toString() {
    return lines.join("\n");
  }
}
