import utest.UTest;
import utest.ui.Report;

class TestAll {
  public static function main() {
    UTest.run([
      new thx.text.TestInflections(),
      new thx.text.TestTable(),
      new thx.text.TestTitleCase()
    ]);
  }
}
