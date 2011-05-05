@booloperator
Feature: Calculate complexity for code that includes BOOLEAN decisions

  Scenario: IF statement with BOOLEAN &&
    Given javascript code as:
    """
      function foo() {
        var bar,baz;
        if(bar && baz) {}
      };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

  Scenario: IF statement with BOOLEAN ||
    Given javascript code as:
    """
      function foo() {
        var bar,baz;
        if(bar || baz) {}
      };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

  Scenario: IF statement with multiple BOOLEAN &&
    Given javascript code as:
    """
      function foo() {
        var bar,baz;
        if(bar && baz && bar) {}
      };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "4"

    Scenario: IF statement with multiple BOOLEAN operators
    Given javascript code as:
    """
      function foo() {
        var bar,baz;
        if(bar && baz || bar && baz) {}
      };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "5"