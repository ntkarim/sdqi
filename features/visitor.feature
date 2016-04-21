Feature: Visitor

  In order to know if visitors can see the links which will take them to table data and charts.

  Scenario: Only logged in users should be able to navigate to tabular data page and visualization page

    Given I am a guest
    When I visit the main page
    Then I should see a link for Stastical View
    Then I go to View in Tables
    Then I see Select Country
    Then I see Select Subject
    Then I see Select Year Range
    Then I should see a Search button
    Then I should click on the Search button
    Then I see filtered page
    Then I do not see export 
    Then I visit View in Charts
    Then I see Select Country
    Then I see Select Subject
    Then I see Select Year Range
    Then I should see a Search button
    Then I should click on the Search button
    Then I see the charts
