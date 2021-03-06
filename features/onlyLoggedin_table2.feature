Feature: onlyLoggedin_table2

  In order to make sure only the logged in Users are able to navigate to the tabular as well as visualization pages

  Scenario: Logged in User privileges.

  Only logged in users should be able to see the Statistical View link

    Given I am a visitor to choose two countries
    When I visit the main page
    When I am signed in
    Then I should see a link for Stastical View
    Then I go to View in Tables
    Then I see Select Country
    Then I see Select Subject
    Then I see Select Year Range
    Then I should see a Search button
    Then I should click on the Search button for two countries
    Then I see filtered page
    Then I see export
