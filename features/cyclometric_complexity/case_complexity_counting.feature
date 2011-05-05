@switch
Feature: Calculate CASE/DEFAULT complexity for a stand alone Javascript function

  Scenario: SWITCH with DEFAULT only
    Given javascript code as:
    """
      function foo() {
        var bar;
        switch(bar) {
          default:
          //do something
          }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: SWITCH with single CASE statement
    Given javascript code as:
    """
      function foo() {
        var bar;
        switch(bar) {
          case true:
          //do something
          }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: SWITCH with single CASE and it breaks out the SWITCH statements
    Given javascript code as:
    """
      function foo() {
        var bar;
        switch(bar) {
          case true:
            //do something
            break;
          }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: SWITCH with multiple CASE and each breaks out the SWITCH
    Given javascript code as:
    """
      function foo() {
        var bar;
        switch(bar) {
          case true:
            //do something
            break;

          case false:
            //do something
            break;
          }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

  Scenario: SWITCH with multiple CASE and neither break out the SWITCH
    Given javascript code as:
    """
      function foo() {
        var bar, temp;

        switch(bar) {
          case true:
            temp = "first"
            //do something

          case false:
             temp = "second"
             //do something
          }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"    


   Scenario: SWITCH with multiple CASE with no-ops are considered as a single Case
    Given javascript code as:
    """
      function foo() {
        var bar, temp;

        switch(bar) {
          case true:
          case false:
          case "blah":
          }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: SWITCH with multiple CASE with no-ops and Default
    Given javascript code as:
    """
      function foo() {
        var bar, temp;

        switch(bar) {
          case true:
          case false:
          default:
          }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"