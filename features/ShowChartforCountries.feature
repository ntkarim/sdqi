Feature: ShowChartforCountries

  To check if all three visualization techniques are displayed if some countries are selected

  Scenario: After a registered user visits the chart view of countries and selected some countries, then the visualizations
    should be displayed for the selected countries

    Given I am registered user
    And I am logged in as the user
    Then I should see the link for viewing visualizations
    And I visit it
    And I select some countries and select for visualization
    Then I should see the visualizations
    And I should see the items in tabular view


