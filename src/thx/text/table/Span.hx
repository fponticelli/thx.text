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
