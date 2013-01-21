Feature: Create a truecrypt volume

  Scenario: create a plain 'ole volume with the name provided
    Given I don't have a directory called "secret"
    And there is no file called "secret.tc"
    When I type "coy create secret"
    Then I should see a file called "secret.tc"
