Feature: Output JSON to describe calls within a class

  Scenario: Create empty graphdata node when there is no javascript
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

    Scenario: Create graphdata with single function node when there is an empty functio
      Given javascript code as:
      """
        function myFunction(){}
      """
      When I run the graph analysis on it
      Then the JSON object returned is:
      """
      {
      "graphdata" :{
        "myFunction":{}
      }
      """