Feature: Visitor

  In order to know if visitors can see the links which will take them to table data and charts.

  Scenario: Only logged in users should be able to navigate to tabular data page and visualization page

    Given I am a guest
    When I visit the project page
    Then I should see a link for the signup
    When I click the link for the signup
    Then I should see a form for signup
    When I click the button for signup
    Then I should see the user logged in