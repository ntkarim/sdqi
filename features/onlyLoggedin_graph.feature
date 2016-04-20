Feature: onlyLoggedin_graph

  In order to make sure only the logged in Users are able to navigate to the tabular as well as visualization pages

  Scenario: Logged in User privileges.

  Only logged in users should be able to see the Statistical View link

    Given I am a visitor
    When I visit the main page
    When I am signed in
    Then I should see a link for Stastical View
    Then I go to View in Tables
    Then I see Select Country
    Then I see Select Subject
    Then I see Select Year Range
    Then I click Search button
    Then I see filtered page
    Then I see export
    Then I visit View in Charts
    Then I see Select Country
    Then I see Select Subject
    Then I see Select Year Range
    Then I click Search button
    Then I see the charts
