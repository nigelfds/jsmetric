@ifelse
Feature: Calculate IF/ELSE complexity for a stand alone Javascript function

  Scenario: No branches
    Given javascript code as:
    """
      function foo() { };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "1"

  Scenario: Just one IF statement
    Given javascript code as:
    """
      function foo() {
        if (true) {
          // do something
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: 2 sequential IF statements
    Given javascript code as:
    """
      function foo() {
        if (true) {
          // do something
        }
        if (true) {
          // do something else
        }        
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

  Scenario: 2 nested IF statements
    Given javascript code as:
    """
      function foo() {
        if (true) {
          // do something
          if (true) {
            // do something else
          }
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

  Scenario: A single IF with Else statement
    Given javascript code as:
    """
      function foo() {
        if (true) {
          // do something
        }
        else {
          // do something else
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: 2 nested IF/Else statements
    Given javascript code as:
    """
      function foo() {
        if (true) {
          // do something
          if (true) {
            // do something else
          }
          else {
            // do this
          }
        }
        else {
          // do that
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

  Scenario: An IF-ELSE-IF type scenario
    Given javascript code as:
    """
      function foo() {
        if (true) {
        }
        else if(true) {
          // do that
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

  Scenario: An IF-ELSE-IF and then ELSE type scenario
    Given javascript code as:
    """
      function foo() {
        if (true) {
          // do something
        }
        else if(true) {
          // do this
        }
        else {
          // do that
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"


  Scenario: A nested IF-ELSE-IF type scenario
    Given javascript code as:
    """
      function foo() {
        if (true) {
          if (true) {
          }
          else if(true) {
            // do that
          }
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "4"

  Scenario: Multiple nested IF-ELSE-IF type scenario
    Given javascript code as:
    """
      function foo() {
        if (true) {
          if (true) {
            // do this
          }
          else if(true) {
            // do that
          }
        }
        else if(true) {
            // do something
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "5"

  Scenario: IF statement implied with ?
    Given javascript code as:
    """
      function foo() {
        (true)? true : false;
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"


  Scenario: IF statement nested inside a ternary operator
    Given javascript code as:
    """
      function foo() {
        (true)? "" : (false) ? true :"" ;
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"
