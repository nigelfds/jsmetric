Feature: Calculate complexity for a stand alone Javascript function

  Scenario: No branches
    Given javascript code as:
    """
      function foo() { };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "1"
