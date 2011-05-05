@reports
Feature: Generate a report for a given JS file

Scenario: CC and Function name report generated for single sample JS file
  Given a sample JS file called "foobar"
  When the CC report target in run on it
  Then the contents of the report are as follows
  """
  Name, CC
  Klass,3
  constructor,2
  Annonymous,2
  """
