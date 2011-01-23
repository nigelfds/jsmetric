Feature: Calculate number of functions for a stand alone Javascript snippet

  Scenario: Single javascript function
    Given javascript code as:
    """
      function foo() {};
    """
    When I run the complexity analysis on it
    Then the number of functions is reported as "1"