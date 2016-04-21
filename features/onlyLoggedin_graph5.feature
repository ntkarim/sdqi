Feature: onlyLoggedin_graph5

  In order to make sure only the logged in Users are able to navigate to the tabular as well as visualization pages

  Scenario: Logged in User privileges.

  Only logged in users should be able to see the Statistical View link

    Given I am a visitor to choose three countries and three subjects
    When I visit the main page
    When I am signed in
    Then I should see a link for Stastical View
    Then I visit View in Charts
    Then I see Select Country
    Then I see Select Subject
    Then I see Select Year Range
    Then I should see a Search button
    Then I should click on the Search button for three countries and three subjects
    Then I see the charts
