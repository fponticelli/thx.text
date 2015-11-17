package thx.text.table;

class Style implements IStyle {
  @:isVar public var border(get, set) : BorderStyle;
  @:isVar public var maxHeight(get, set) : Null<Int>;
  @:isVar public var maxWidth(get, set) : Null<Int>;
  public function new() {}

  function get_border()
    return border;

  function set_border(value : BorderStyle)
    return border = value;

  function get_maxHeight() : Null<Int>
    return maxHeight;

  function set_maxHeight(value : Null<Int>) : Null<Int>
    return maxHeight = value;

  function get_maxWidth() : Null<Int>
    return maxWidth;

  function set_maxWidth(value : Null<Int>) : Null<Int>
    return maxWidth = value;
}

class CompositeStyle extends Style {
  var parents : Array<IStyle>;
  public function new(parents : Array<IStyle>) {
    super();
    this.parents = parents;
  }

  override function get_border()
    return getProperty("border");

  override function set_border(value : BorderStyle)
    return border = value;

  override function get_maxHeight() : Null<Int>
    return getProperty("maxHeight");

  override function set_maxHeight(value : Null<Int>) : Null<Int>
    return maxHeight = value;

  override function get_maxWidth() : Null<Int>
    return getProperty("maxWidth");

  override function set_maxWidth(value : Null<Int>) : Null<Int>
    return maxWidth = value;

  // TODO, this should expand to a macro
  function getProperty<T>(name : String) : Null<T> {
    var value = Reflect.field(this, name);
    if(null != value)
      return value;
    for(parent in parents) {
      value = Reflect.field(parent, name);
      if(null != value)
        return value;
    }
    return null;
  }
}

class DefaultStyle implements IStyle {
  public static var instance(default, null) : DefaultStyle = new DefaultStyle();
  public static var defaultBorder : BorderStyle = Body;
  public static var defaultMaxHeight : Null<Int> = null;
  public static var defaultMaxWidth : Null<Int> = null;

  public var border(get, set) : BorderStyle;
  public var maxHeight(get, set) : Null<Int>;
  public var maxWidth(get, set) : Null<Int>;

  public function new() {}

  function get_border() : BorderStyle
    return defaultBorder;

  function set_border(value : BorderStyle) : BorderStyle
    return defaultBorder = value;

  function get_maxHeight() : Null<Int>
    return defaultMaxHeight;

  function set_maxHeight(value : Null<Int>) : Null<Int>
    return defaultMaxHeight = value;

  function get_maxWidth() : Null<Int>
    return defaultMaxWidth;

  function set_maxWidth(value : Null<Int>) : Null<Int>
    return defaultMaxWidth = value;
}

interface IStyle {
  public var border(get, set) : BorderStyle;
  public var maxWidth(get, set) : Null<Int>;
  public var maxHeight(get, set) : Null<Int>;
}

enum BorderStyle {
  Header;
  Body;
  None;
}
