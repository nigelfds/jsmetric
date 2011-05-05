@loops
Feature: Calculate LOOP complexity for a stand alone Javascript function

  Scenario: Single FOR loop
    Given javascript code as:
    """
      function foo() {
        var i;
        for(i=1;i<3;i++) {}
      };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: Single WHILE loop
    Given javascript code as:
    """
      function foo() {
        while(true) {}
      };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

  Scenario: Single DO/WHILE  loop
    Given javascript code as:
    """
      function foo() {
        do { }
        while (true);
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "2"

    Scenario: Multiple WHILE/DO loops in sequence
    Given javascript code as:
    """
      function foo() {
        while (true)
        {
        // do something
        }

        do {
          // something else
        }
        while (true);
      }
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"

    Scenario: Nested FOR loops
      Given javascript code as:
      """
        function foo() {
          var i,j;
          for(i=1;i<3;i++) {
            for(j=1;j<3;j++) {
            }
          }
        };
      """
      When I run the complexity analysis on it
      Then the complexity is reported as "3"

  Scenario: Nested FOR loops
    Given javascript code as:
    """
      function foo() {
       while(true) {
         do {

         }
         while(true)
       }
      };
    """
    When I run the complexity analysis on it
    Then the complexity is reported as "3"
