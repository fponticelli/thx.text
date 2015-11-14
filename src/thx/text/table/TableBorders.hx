typedef CellBorders = {
  horizontal : String,
  vertical : String,
  bottomLeft : String,
  bottomRight : String,
  topLeft : String,
  topRight : String,
  crossBottom : String,
  crossTop : String,
  crossLeft : String,
  crossRight : String
}

typedef CrossBorders = {
  bottomALeftB : String,
  bottomARightB : String,
  topALeftB : String,
  topARightB : String,
  crossABottomB : String,
  crossATopB : String,
  crossALeftB : String,
  crossARightB : String
}

class DefaultBorders {
  public static var header : CellBorders = {
    horizontal : "━",
    vertical : "┃",
    bottomLeft : "┗",
    bottomRight : "┛",
    topLeft : "┏",
    topRight : "┓",
    crossBottom : "┳",
    crossTop : "┻",
    crossLeft : "┫",
    crossRight : "┣"
  };

  public static var body : CellBorders = {
    horizontal : "─",
    vertical : "│",
    bottom : "",
    bottomLeft : "└",
    bottomRight : "┘",
    topLeft : "┌",
    topRight : "┐",
    crossBottom : "┬",
    crossTop : "┴",
    crossLeft : "┤",
    crossRight : "├"
  };
}
