package thx.text;

import utest.Assert;
using thx.Arrays;
using thx.text.TitleCase;

class TestTitleCase {
  public function new() { }

  public function testTitleCase() {
    var tests = [
      { expected: "", src: "", ucfirst:true },
      { expected: "A Word", src: "a word", ucfirst:true },
      { expected: "My Title", src: "my title", ucfirst:true },
      { expected: "The Title", src: "the title", ucfirst:true },
      { expected: "the Title", src: "the title", ucfirst:false },
      { expected: "We Run Around", src: "we run around", ucfirst:true },
      { expected: "A TITLE about TITLES", src: "A TITLE ABOUT TITLES", ucfirst:true },
      { expected: "a TITLE about TITLES", src: "A TITLE ABOUT TITLES", ucfirst:false },
      { expected: "They Run around the World", src: "they run AROUND the world", ucfirst:true },
      { expected: "Round eMail", src: "round eMail", ucfirst:true },
      { expected: "eMail for Everyone Around", src: "eMail for everyone around", ucfirst:true },
      { expected: "My Title: The Story of My Life", src: "my title: the story of my life", ucfirst:true },
      { expected: "My Title: The Story of My Life", src: "my title: the story of my life", ucfirst:false },
      { expected: "I Didn't See You There-There-Before", src: "i didn't see you there-there-before", ucfirst:false },
      { expected: "Life on the round-About", src: "Life on the round-about", ucfirst:true },
      { expected: "Writing E-Mail", src: "writing e-mail", ucfirst:true },
      { expected: "The Custom Words", src: "the custom words", ucfirst:true}
    ];

    tests.each(function(t) {
      var s = t.src.toTitleCase(t.ucfirst);
      Assert.equals(t.expected, s, 'Expected "${t.expected}" but got "$s" for "${t.src}" with ucfirst: ${t.ucfirst}');
    });
  }

  public function testCustomWords() {
    Assert.equals("The custom Words", "the custom words".toTitleCaseWithWords(["custom"]));
  }
}
