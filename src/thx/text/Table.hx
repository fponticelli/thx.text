package thx.text;

using thx.Arrays;
using thx.Ints;
using thx.Strings;
using haxe.Utf8;

import thx.DateTime;
import thx.Time;

import thx.culture.Culture;
import thx.format.NumberFormat;
import thx.format.DateFormat;
import thx.format.TimeFormat;

class Table {
/*
  public static var defaultCulture : Culture = thx.culture.Embed.culture("En-US");
  public static var defaultFormat : CellValue -> Culture -> StringBlock = function(value, culture) {
    switch value {
      case StringCell(v): return StringBlock.fromString(v);
      case _: // do nothing
    }
    var s = switch value {
      case IntCell(v):
        NumberFormat.integer(v, culture);
      case FloatCell(v):
        NumberFormat.number(v, 2, culture);
      case StringCell(v):
        v;
      case BoolCell(v):
        // TODO, change to Utf8 chars
        v ? "T" : "F";
      case DateCell(v):
        v.toString();
      case DateTimeCell(v):
        DateFormat.iso8601(v, culture);
      case TimeCell(v):
        TimeFormat.timeLong(v, culture);
      case NA:
        // TODO, better symbol
        "NA";
    };
    return new StringBlock([s]);
  };
*/
  public var rows(default, null) : Int;
  public var cols(default, null) : Int;
  public var values : Map<Int, Map<Int, Cell>>;
  public function new() {
    rows = 0;
    cols = 0;
    values = new Map();
  }

  public function set(cell : Cell, row : Int, col : Int) {
    var r = getRow(row);
    r.set(col, cell);
    rows = rows.max(row + cell.spanHeight());
    cols = cols.max(col + cell.spanWidth());
  }

  public function get(row : Int, col : Int) : Cell {
    var r = values.get(row);
    if(null == r)
      return new Cell(NA);
    var c = r.get(col);
    return null != c ? c : new Cell(NA);
  }

  public function toString() : String {
    return null;
  }

  // format value (with filling)
  // align value horizontal
  // align value vertical
  // padding
  // borders

  function getRow(row : Int) {
    var r = values.get(row);
    if(null == r)
      values.set(row, r = new Map());
    return r;
  }
}

class StringBlock {
  public static function fromString(s : String) : StringBlock {
    var lines = (~/(\r\n|\n\r|\n|\r)/g).split(s);
    return new StringBlock(lines);
  }

  var lines : Array<String>;
  public var width(default, null) : Int;
  public var height(default, null) : Int;

  public function new(lines : Array<String>) {
    this.lines = lines;
    this.width = lines.reduce(function(width : Int, line) return width.max(Utf8.length(line)), 0);
    this.height = lines.length;
  }

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

  public function toString() {
    return lines.join("\n");
  }
}

class Cell {
  public static function empty(?span : CellSpan)
    return new Cell(Empty, span);

  public static function na(?span : CellSpan)
    return new Cell(NA, span);

  public static function int(v : Int, ?span : CellSpan)
    return new Cell(IntCell(v), span);

  public static function float(v : Float, ?span : CellSpan)
    return new Cell(FloatCell(v), span);

  public static function string(v : String, ?span : CellSpan)
    return new Cell(StringCell(v), span);

  public static function bool(v : Bool, ?span : CellSpan)
    return new Cell(BoolCell(v), span);

  public static function date(v : Date, ?span : CellSpan)
    return new Cell(DateCell(v), span);

  public static function dateTime(v : DateTime, ?span : CellSpan)
    return new Cell(DateTimeCell(v), span);

  public static function time(v : Time, ?span : CellSpan)
    return new Cell(TimeCell(v), span);

  public var value : CellValue;
  public var span : CellSpan;
  public function new(value : CellValue, ?span : CellSpan) {
    this.value = value;
    this.span = null != span ? span : NoSpan;
  }

  public function spanHeight()
    return switch span {
    case SpanVertical(rows), Span(rows, _):
        rows;
      case _:
        1;
    };

    public function spanWidth()
      return switch span {
        case SpanHorizontal(cols), Span(_, cols):
          cols;
        case _:
          1;
      };
/*
  public function symbolFromRight() {
    var s = toString();
    return switch halign {
      case OnSymbol(symbol):
        var parts = s.split(symbol);
        if(parts.length == 1)
          0
        else
          Utf8.length(parts.last());
      case _:
        0;
    };
  }

  function get_halign() : HAlign {
    if(null != _halign)
      return _halign;
    return switch value {
      case IntCell(_): Right;
      case FloatCell(_): OnSymbol(".");
      case DateCell(_), DateTimeCell(_), TimeCell(_), StringCell(_): Left;
      case BoolCell(_), NA: Center;
    };
  }

  function set_halign(value : HAlign) : HAlign
    return this._halign = value;

  function get_valign() : VAlign {
    if(null != _valign)
      return _valign;
    return Center;
  }

  function set_valign(value : VAlign) : VAlign
    return this._valign = value;

  function get_format() : CellValue -> StringBlock {
    if(null != _format)
      return _format;
    return Table.defaultFormat.bind(_, culture);
  }

  function set_format(value : CellValue -> StringBlock) : CellValue -> StringBlock
    return this._format = value;

  function get_culture() : Culture {
    if(null != _culture)
      return _culture;
    return Table.defaultCulture;
  }

  function set_culture(value : Culture) : Culture
    return this._culture = value;
*/
}

enum HAlign {
  Left;
  Right;
  Center;
  OnSymbol(symbol : String);
}

enum VAlign {
  Top;
  Center;
  Bottom;
}

enum CellValue {
  IntCell(v : Int);
  FloatCell(v : Float); // can be Infinity or NaN
  StringCell(v : String); // can be null
  BoolCell(v : Bool);
  DateCell(v : Date);
  DateTimeCell(v : DateTime);
  TimeCell(v : Time);
  Empty;
  NA;
}

enum CellSpan {
  NoSpan;
  Span(rows : Int, cols : Int);
  SpanHorizontal(cols : Int);
  SpanVertical(rows : Int);
  FillHorizontal;
  FillVertical;
  Fill;
}
