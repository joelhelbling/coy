@ignore
Feature: Check the project's .gitignore file to ensure
  coy assets will not be inadvertently committed/pushed/published.

  @not-ignored @auto-add @git
  Scenario: no ignore file, but we agree to automatic add (Git)
    Given the current directory is a git repo
    And a file named ".gitignore" should not exist
    And I run `coy create secret --password fuzz` interactively
    When I type "Y"
    And I type "Y"
    Then the output should contain:
    """
    add .coy to this project's .gitignore file automatically?
    """
    And the output should contain:
    """
    add secret to this project's .gitignore file automatically?
    """
    And the output should contain:
    """
    Protected directory "secret" successfully created.
    """
    And the file ".gitignore" should contain ".coy"
    And the file ".gitignore" should contain "secret"

  @not-ignored @auto-add @hg
  Scenario: no ignore file, but we agree to automatic add (Hg)
    Given I have an appropriate .gitignore file
    Given the current directory is a mercurial repo
    And a file named ".hgignore" should not exist
    And I run `coy create secret --password fuzz` interactively
    When I type "Y"
    And I type "Y"
    Then the output should contain:
    """
    add .coy to this project's .hgignore file automatically?
    """
    And the output should contain:
    """
    add secret to this project's .hgignore file automatically?
    """
    And the output should contain:
    """
    Protected directory "secret" successfully created.
    """
    And the file ".hgignore" should contain ".coy"
    And the file ".hgignore" should contain "secret"

  @not-ignored @auto-add @svn
  Scenario: no ignore file, but we agree to automatic add (SVN)
    Given I have an appropriate .gitignore file
    Given the current directory is a svn repo
    And a file named ".svnignore" should not exist
    And I run `coy create secret --password fuzz` interactively
    When I type "Y"
    And I type "Y"
    Then the output should contain:
    """
    add .coy to this project's .svnignore file automatically?
    """
    And the output should contain:
    """
    add secret to this project's .svnignore file automatically?
    """
    And the output should contain:
    """
    Protected directory "secret" successfully created.
    """
    And the file ".svnignore" should contain ".coy"
    And the file ".svnignore" should contain "secret"

  @no-auto-add @git
  Scenario: volume not in ignore file, and we decline auto-add (Git)
    Given we ignore coy with git
    And I run `coy create secret --password fuzz` interactively
    When I type "n"
    Then the output should contain:
    """
    WARNING: please add "secret" to this project's .gitignore file!
    """

  @no-auto-add @hg
  Scenario: volume not in ignore file, and we decline auto-add (Hg)
    Given I have an appropriate .gitignore file
    And the current directory is a mercurial repo
    And we ignore coy with hg
    And I run `coy create secret --password fuzz` interactively
    When I type "n"
    Then the output should contain:
    """
    WARNING: please add "secret" to this project's .hgignore file!
    """

  @no-auto-add @svn
  Scenario: volume not in ignore file, and we decline auto-add (Git)
    Given I have an appropriate .gitignore file
    And the current directory is a svn repo
    And we ignore coy with svn
    And I run `coy create secret --password fuzz` interactively
    When I type "n"
    Then the output should contain:
    """
    WARNING: please add "secret" to this project's .svnignore file!
    """

  @already-ignored @git
  Scenario: ignore file includes both .coy and "secret" (Git)
    Given a .gitignore with:
    """
    .coy
    secret
    """
    When I run `coy create secret -p fuzz`
    Then the output should contain "success"

  @already-ignored @hg
  Scenario: ignore file includes both .coy and "secret" (Hg)
    Given I have an appropriate .gitignore file
    And the current directory is a mercurial repo
    Given a .hgignore with:
    """
    .coy
    secret
    """
    When I run `coy create secret -p fuzz`
    Then the output should contain "success"
  @already-ignored @svn
  Scenario: ignore file includes both .coy and "secret" (SVN)
    Given I have an appropriate .gitignore file
    And the current directory is a svn repo
    Given a .svnignore with:
    """
    .coy
    secret
    """
    When I run `coy create secret -p fuzz`
    Then the output should contain "success"
