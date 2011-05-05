Feature: Output JSON to describe calls within a class

  Scenario: Empty graph data when there is no JavaScript
    Given javascript code as:
      """

      """
    When I run the graph analysis on it
    Then the JSON object returned is:
    """
    {
      "graphdata" : {}
    }
    """