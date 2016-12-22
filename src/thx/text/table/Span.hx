package thx.text.table;

enum Span {
  NoSpan;
  SpanBoth(rows : Int, cols : Int);
  SpanRight(cols : Int);
  SpanDown(rows : Int);
  FillRight;
  FillDown;
  FillBoth;
}

class Spans {
  public static function compare(a: Span, b: Span): Int {
    return switch [a, b] {
      case [SpanBoth(r1, c1), SpanBoth(r2, c2)] if(r1 == r2):
        c1 - c2;
      case [SpanBoth(r1, _), SpanBoth(r2, _)]:
        r1 - r2;
      case [SpanRight(c1), SpanRight(c2)]:
        c1 - c2;
      case [SpanDown(r1), SpanDown(r2)]:
        r1 - r2;
      case [NoSpan, NoSpan] | [FillRight, FillRight] | [FillDown, FillDown] | [FillBoth, FillBoth]:
        0;
      case [NoSpan, _]:
        -1;
      case [SpanBoth(_, _), NoSpan]:
        1;
      case [SpanBoth(_), _]:
        -1;
      case [SpanRight(_), NoSpan]:
        1;
      case [SpanRight(_), SpanBoth(_, _)]:
        1;
      case [SpanRight(_), _]:
        -1;
      case [SpanDown(_), NoSpan]:
        1;
      case [SpanDown(_), SpanBoth(_, _)]:
        1;
      case [SpanDown(_), SpanRight(_)]:
        1;
      case [SpanDown(_), _]:
        -1;
      case [FillRight, NoSpan]:
        1;
      case [FillRight, SpanBoth(_, _)]:
        1;
      case [FillRight, SpanRight(_)]:
        1;
      case [FillRight, SpanDown(_)]:
        1;
      case [FillRight, _]:
        -1;
      case [FillDown, NoSpan]:
        1;
      case [FillDown, SpanBoth(_, _)]:
        1;
      case [FillDown, SpanRight(_)]:
        1;
      case [FillDown, SpanDown(_)]:
        1;
      case [FillDown, FillRight]:
        1;
      case [FillDown, _]:
        -1;
      case [FillBoth, NoSpan]:
        1;
      case [FillBoth, SpanBoth(_, _)]:
        1;
      case [FillBoth, SpanRight(_)]:
        1;
      case [FillBoth, SpanDown(_)]:
        1;
      case [FillBoth, FillRight]:
        1;
      case [FillBoth, FillDown]:
        1;
    }
  }
}
