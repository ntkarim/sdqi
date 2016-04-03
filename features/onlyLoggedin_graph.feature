Feature: onlyLoggedin_graph

  In order to make sure only the logged in Users are able to navigate to the tabular as well as visualization pages

  Scenario: Logged in User privileges.

  Only logged in users should be able to see the Statistical View link

    Given I am a visitor
    When I visit the main page
    Then I should not see a link for Statistical View
    When I am signed in
    Then I should see a link for Stastical View
