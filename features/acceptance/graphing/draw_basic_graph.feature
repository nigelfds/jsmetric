Feature: Output JSON to describe calls within a class

  Scenario: Create empty graphdata node when there is no javascript
    Given javascript code as:
      """

      """
    When I run the graph analysis on it
    Then the JSON object returned is
    """
    graphdata {
    }
    """
