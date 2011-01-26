Feature: Calculate number of functions for a stand alone Javascript snippet

  Scenario: Single javascript function
    Given javascript code as:
    """
      function foo() {};
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "1"

  Scenario: Multiple javascript functions
    Given javascript code as:
    """
      function foo() {};
      function bar() {};
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "2"

  Scenario: Multiple javascript functions nested
    Given javascript code as:
    """
      function foo() {
        function bar() {};
      };
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "2"


# WIP
#  Scenario: Single outer function with inner private function
#    Given javascript code as:
#    """
#      function foo() {
#        var baz = function() {};
#      };
#    """
#    When I run the complexity analysis on it
#    Then the number of functions is reported as "2"
#
#  Scenario: Single outer function with inner public function
#    Given javascript code as:
#    """
#      function foo() {
#        this.baz = function() {};
#      };
#    """
#    When I run the complexity analysis on it
#    Then the number of functions is reported as "2"

