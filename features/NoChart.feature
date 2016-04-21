Feature: NoChart

  To check if none of the visualizations are present when none of the countries are selected when visiting the page for the first time

  Scenario: After a registered user visits the chart view of countries, then s/he should not see any chart

    Given I am registered member
    And I am logged in as the member
    Then I should see the link for viewing I visit it
    Then I should not see any of the visualization techniques since I do not have any country selected


