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

import thx.text.table.TableBorders;

class Table {
  public static var defaultCulture : Culture = thx.culture.Embed.culture("En-US");
  public static var defaultFormat : CellValue -> Int -> StringBlock = function(value, maxWidth) {
    switch value {
      case StringCell(v):
        if(maxWidth > 0)
          v = v.wrapColumns(maxWidth);
        return StringBlock.fromString(v);
      case _: // do nothing
    }
    var s = switch value {
      case IntCell(v):
        NumberFormat.integer(v, defaultCulture);
      case FloatCell(v):
        NumberFormat.number(v, 2, defaultCulture);
      case StringCell(v):
        v;
      case BoolCell(v):
        // TODO, change to Utf8 chars
        v ? "T" : "F";
      case DateCell(v):
        v.toString();
      case DateTimeCell(v):
        DateFormat.iso8601(v, defaultCulture);
      case TimeCell(v):
        TimeFormat.timeLong(v, defaultCulture);
      case NA:
        // TODO, better symbol
        "NA";
      case Empty:
        "";
    };
    return new StringBlock([s]);
  };

  public var rows(default, null) : Int;
  public var cols(default, null) : Int;
  public var values : Map<Int, Map<Int, Cell>>;
  public var bodyBorders : CellBorders;
  public var headerBorders : CellBorders;
  public var padding : Int;
  public function new(?bodyBorders : CellBorders, ?headerBorders : CellBorders, ?padding : Int = 1) {
    rows = 0;
    cols = 0;
    values = new Map();
    this.bodyBorders = null != bodyBorders ? bodyBorders : DefaultBorders.body;
    this.headerBorders = null != headerBorders ? headerBorders : DefaultBorders.header;
    this.padding = padding;
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

  public function exists(row : Int, col : Int) : Bool {
    var r = values.get(row);
    if(null == r)
      return false;
    return r.exists(col);
  }

  public function toString() : String {
    var formatters = buildMatrix(rows, cols, function(_, _) return defaultFormat);
    var maxWidths = buildMatrix(rows, cols, function(_, _) return 0);
    var blocks = buildMatrix(rows, cols, function(r, c) {
      if(!exists(r, c))
        return StringBlock.empty();
      else
        return formatters[r][c](get(r, c).value, maxWidths[r][c]);
    });
    var colSizes = [],
        rowSize  = [];
    for(col in 0...cols) {

    }
    /*
    var sizes = buildMatrix(rows, cols, function(_, _) return { width : 0, height : 0 });
    var cells = buildMatrix(rows, cols, function(r, c) return get(r, c));
    // fix spans for cells

    var haligns = buildMatrix(rows, cols, function(_, _) : HAlign return Center);
    var valigns = buildMatrix(rows, cols, function(_, _) : VAlign return Top);
    var isBody = buildMatrix(rows, cols, function(_, _) return true);
    var values = buildMatrix(rows, cols, function(r, c) {
      return formatters[r][c](cells[r][c].value, maxWidths[r][c]);
    });

    var spansRights = buildMatrix(rows, cols, function(r, c) {
      return false;
    });
    buildMatrix(rows, cols, function(r, c) {
      switch cells[r][c].span {
        case SpanVertical(sr):
          for(i in 1...sr)
            values[r + i][c] = new StringBlock([""]);
          for(i in 0...sr-1)
            spansRights[r + i][c] = true;
        case FillVertical:
          for(i in 1...rows)
            values[r + i][c] = new StringBlock([""]);
          for(i in 0...rows-1)
            spansRights[r + i][c] = true;
        case SpanHorizontal(sc):
          for(i in 1...sc)
            values[r][c + i] = new StringBlock([""]);
          for(i in 0...sc-1)
            spansRights[r][c + i] = true;
        case FillHorizontal:
          for(i in 1...cols)
            values[r][c + i] = new StringBlock([""]);
          for(i in 0...cols-1)
            spansRights[r][c + i] = true;
        case SpanBoth(sr, sc):
          for(i in 1...sc)
            for(j in 1...sr)
              values[r + j][c + i] = new StringBlock([""]);
          for(i in 0...sc-1)
            for(j in 0...sr-1)
              spansRights[r + j][c + i] = true;
        case Fill:
          for(i in 1...cols)
            for(j in 1...rows)
              values[r + j][c + i] = new StringBlock([""]);
          for(i in 0...cols-1)
            for(j in 0...rows-1)
              spansRights[r + j][c + i] = true;
        case _:
      }
      return null;
    });
    var colWidths = [];
    for(c in 0...cols) {
      var width = 0;
      for(r in 0...rows) {
        var spanWidth = cells[r][c].spanWidth();
        if(spanWidth > 1) {
          var cellWidth = values[r][c].width + padding * 2 + 1,
              spansMin = Math.floor(cellWidth / spanWidth),
              spansMax = Math.ceil(cellWidth / spanWidth);

          values[r][c].width = spansMax;
          for(i in 1...spanWidth-1) {
            values[r][c+i].width = spansMin;
          }
        } else {
          width = width.max(values[r][c].width);
        }
      }
      colWidths[c] = width;
    }
    var rowHeights = [];
    for(c in 0...cols) {
      var height = 0;
      for(r in 0...rows) {
        height = height.max(values[r][c].height);
      }
      rowHeights[c] = height;
    }
    var buf = "";
    for(r in 0...rows) {
      // corner
      if(r == 0)
        buf += getBorder(isBody[0][0]).topLeft;
      else
        buf += getBorder(isBody[0][0]).crossRight;
      // line above
      for(c in 0...cols) {
        buf += getHorizontalBorder(isBody[r][c], colWidths[c] + padding * 2);
        if(c < cols - 1) {
          if(spansRights[r][c])
            buf += getBorder(isBody[0][0]).horizontal;
          else
            if(r == 0)
              buf += getBorder(isBody[0][0]).crossBottom;
            else
              buf += getBorder(isBody[0][0]).cross;
        } else {
          if(r == 0)
            buf += getBorder(isBody[0][0]).topRight;
          else
            buf += getBorder(isBody[0][0]).crossLeft;
        }
      }
      buf += "\n";
      // content
      var lines = rowHeights[r];
      //width : Int, halign : HAlign, valign : VAlign, totalLines : Int, symbolFromRight : Int
      for(line in 0...lines) {
        buf += getBorder(isBody[r][0]).vertical;
        for(c in 0...cols) {
          buf += " ".repeat(padding);
          var s = values[r][c].getLine(line,
                    colWidths[c],
                    haligns[r][c],
                    valigns[r][c],
                    lines,
                    0
                  );
          buf += s;
          buf += " ".repeat(padding);
          buf += getBorder(isBody[r][cols-1]).vertical;
        }
        buf += "\n";
      }
    }
    buf += getBorder(isBody[rows-1][0]).bottomLeft;
    // line below
    for(c in 0...cols) {
      buf += getHorizontalBorder(isBody[rows-1][c], colWidths[c] + padding * 2);
      if(c < cols - 1)
        buf += getBorder(isBody[rows-1][cols-1]).crossTop;
      else
        buf += getBorder(isBody[rows-1][cols-1]).bottomRight;
    }

    return buf;
    */
  }

  function getBorder(isBody : Bool) {
    return isBody ? bodyBorders : headerBorders;
  }

  function hasVerticalBorder(isBody : Bool)
    return getBorder(isBody).vertical.hasContent();

  function hasHorizontalBorder(isBody : Bool)
    return getBorder(isBody).horizontal.hasContent();

  function getHorizontalBorder(isBody : Bool, length : Int)
    return getBorder(isBody).horizontal.repeat(length);
/*

*=====*============*
| 0-0 |    0-1     |
*=====*============*
| 1-0 |    1-1     |
*-----*------------*
| 2-0 |    2-1     |
*-----*------------*

*/

  static function buildMatrix<T>(rows : Int, cols : Int, fvalue : Int -> Int -> T) : Array<Array<T>>
    return [for(r in 0...rows) [for(c in 0...cols) fvalue(r, c)]];

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
    case SpanVertical(rows), SpanBoth(rows, _):
        rows;
      case _:
        1;
    };

    public function spanWidth()
      return switch span {
        case SpanHorizontal(cols), SpanBoth(_, cols):
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
  SpanBoth(rows : Int, cols : Int);
  SpanHorizontal(cols : Int);
  SpanVertical(rows : Int);
  FillHorizontal;
  FillVertical;
  Fill;
}
