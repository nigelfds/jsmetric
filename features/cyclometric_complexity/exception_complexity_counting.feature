@exceptions
Feature: Calculate TRY/CATCH complexity for a stand alone Javascript function

  Scenario: Single TRY CATCH in a function
    Given javascript code as:
    """
      function foo() {
        try
        {
          //Run some code here
        }
        catch(err)
        {
          //Handle errors here
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: Single TRY FINALLY in a function
    Given javascript code as:
    """
      function foo() {
        try
        {
          //Run some code here
        }
        finally
        {
          //Handle errors here
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

   Scenario: Single TRY CATCH FINALLY in a function
    Given javascript code as:
    """
      function foo() {
        try
        {
          //Run some code here
        }
        catch(err)
        {
          //Handle errors here
        }
        finally
        {
          //Handle errors here
        }
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

  Scenario: Nested TRY inside a CATCH in a function
    Given javascript code as:
    """
      function foo() {
        try
        {
          //Run some code here
        }
        catch(err)
        {

          try
          {
            //Run some code here
          }
          catch (anotherErr)
          {
            //Handle errors here
          }
        }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"
