@gitignore
Feature: Check the project's .gitignore file to ensure
  coy assets will not be inadvertently committed/pushed/published.

  Background:
    Given the current directory is a git repo

  Scenario: no .gitignore
    Given a file named ".gitignore" should not exist
    When I run `coy create secret --password fuzz`
    Then the output should contain:
    """
    This project has no .gitignore file!
    """

  Scenario: .gitignore doesn't include .coy
    Given a .gitignore with:
    """
    not_coy
    """
    When I run `coy create secret -p fuzz`
    Then the output should contain:
    """
    .gitignore does not include '.coy'
    """

  Scenario: .gitignore doesn't include the protected directory
    Given a .gitignore with:
    """
    .coy
    """
    When I run `coy create secret -p fuzz`
    Then the output should contain:
    """
    .gitignore does not include protected directory "secret"
    """

  Scenario: .gitignore includes both .coy and "secret"
    Given a .gitignore with:
    """
    .coy
    secret
    """
    When I run `coy create secret -p fuzz`
    Then the output should contain "success"
