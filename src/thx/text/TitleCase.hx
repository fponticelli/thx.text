package thx.text;

import thx.ERegs;
import thx.ReadonlyArray;

class TitleCase {
  public static var defaultWords = ["and", "aboard", "about", "above", "across", "after", "against", "along", "amid", "among", "anti", "around", "as", "at",
    "before", "behind", "below", "beneath", "beside", "besides", "between", "beyond", "but", "by", "concerning", "considering",
    "despite", "down", "during", "except", "excepting", "excluding", "following", "for", "from", "in", "inside", "into", "like",
    "minus", "near", "of", "off", "on", "onto", "opposite", "outside", "over", "past", "per", "plus", "regarding", "round", "save",
    "since", "than", "through", "to", "toward", "towards", "under", "underneath", "unlike", "until", "up", "upon", "versus", "via",
    "with", "within", "without", "a", "an", "the", "one", "some", "few", "vs", "v.s.", "vs.", "via"];

  static function toTitleCasePartWithWords(str: String, words: ReadonlyArray<String>, ucFirst: Bool): String {
    var pattern = "^(" + words.map(ERegs.escape).join("|") + ")$";

    var ereg = new EReg(pattern, "i");
    var splitter = ~/([^\W_]+[^\s-]*) */g;
    var charBefore = ~/[^\s-]/;
    var isCapital = ~/[A-Z]|\../;

    function conditionalCapitalizeFirst(e: EReg): String {
      var matchedZero = e.matched(0);
      return isCapital.match(e.matched(1).substring(1)) ?
        matchedZero :
        matchedZero.substring(0, 1).toUpperCase() + matchedZero.substring(1);
    }

    function mapValue(e: EReg): String {
      return e.matchedRight().length != 0 && ereg.match(e.matched(1)) && !charBefore.match(str.charAt(e.matchedPos().pos - 1)) ?
        e.matched(0).toLowerCase() :
        conditionalCapitalizeFirst(e);
    }

    return splitter.map(str, ucFirst ? function (e: EReg) {
      return e.matchedPos().pos > 0 ? mapValue(e) : conditionalCapitalizeFirst(e);
    } : mapValue);
  }

  public static function toTitleCaseWithWords(str: String, words: ReadonlyArray<String>, ucFirst = true): String {
    var parts = str.split(": ");
    return [toTitleCasePartWithWords(parts[0], words, ucFirst)].concat(parts.slice(1).map(toTitleCasePartWithWords.bind(_, words, true))).join(": ");
  }

  public static function toTitleCase(str: String, ucFirst = true): String {
    return toTitleCaseWithWords(str, defaultWords, ucFirst);
  }
}
