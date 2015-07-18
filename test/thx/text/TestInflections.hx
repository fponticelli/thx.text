package thx.text;

import utest.Assert;
using thx.text.Inflections;

class TestInflections {
  public function new() { }

  public function testUncountable() {
    Assert.equals("information", "information".pluralize());
    Assert.equals("news", "news".pluralize());
  }

  public function testPluralize() {
    Assert.equals("days", "day".pluralize());
    Assert.equals("women", "woman".pluralize());
    Assert.equals("autobuses", "autobus".pluralize());
    Assert.equals("quizzes", "quiz".pluralize());
  }

  public function testSingularize() {
    Assert.equals("day", "days".singularize());
    Assert.equals("woman", "women".singularize());
    Assert.equals("autobus", "autobuses".singularize());
    Assert.equals("quiz", "quizzes".singularize());
  }
}
