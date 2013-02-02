@truecrypt
Feature: Interact with truecrypt volumes

  Background:
    Given I have an appropriate .gitignore file

  @create
  Scenario Outline: create a plain 'ole volume with the name provided
    Given a file named ".coy/secret.tc" should not exist
    When I run `coy create secret <password_flag> fuzz`
    Then the output should contain:
    """
    Protected directory "secret" successfully created
    """
    And a directory named ".coy" should exist
    And a file named ".coy/secret.tc" should exist

  Examples:
    | password_flag |
    | --password    |
    | -p            |

  @open
  Scenario Outline: open a protected directory
    Given a directory named "foo" should not exist
    And I have a protected directory named "foo" with password "fuzz"
    When I run `coy open foo <password_flag> fuzz`
    Then a protected directory named "foo" should exist

  Examples:
    | password_flag |
    | --password    |
    | -p            |

  @close
  Scenario: close an opened protected directory
    Given I have a protected directory named "bar" with password "fuzz"
    And protected directory "bar" is open
    When I run `coy close bar`
    Then a directory named "bar" should not exist

