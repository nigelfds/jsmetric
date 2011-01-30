Feature: Calculate number of functions for a stand alone Javascript snippet

  Scenario: Only statements and no functions
     Given javascript code as:
     """
       var foo = {} || "";
       var baz = 2;
     """
     When I run the complexity analysis on it
     Then the number of functions is reported as "0"


  Scenario: Single javascript function
    Given javascript code as:
    """
      function foo() {};
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "1"
    And the function name is "foo"

  Scenario: Multiple javascript functions
    Given javascript code as:
    """
      function foo() {};
      function bar() {};
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "2"
    And the function names are:
      | Name |
      | foo  |
      | bar  |

  Scenario: Multiple javascript functions nested
    Given javascript code as:
    """
      function foo() {
        function bar() {};
      };
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "2"


  Scenario: Single outer function with inner private function
    Given javascript code as:
    """
      function foo() {
        var baz = function() {};
      };
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "2"
    And the function names are:
      | Name     |
      | foo      |
      | anonymous/inner |

  Scenario: Single outer function with inner public function
    Given javascript code as:
    """
      function foo() {
        this.baz = function() {};
      };
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "2"
    And the function names are:
      | Name    |
      | foo     |
      | anonymous/inner |

  Scenario: Single javascript function containing the string "function"
    Given javascript code as:
    """
      function foo() {
        return "function";
      };
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "1"
    And the function name is "foo"