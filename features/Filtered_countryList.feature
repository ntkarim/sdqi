Feature: DefaultCountryList

  To check if the default view of the tabular country view is working as expected

  Scenario: After a registered user visits the tabular view of countries, then s/he should see the default country list

    Given I am a registered member
    And I am logged in as a the member
    Then I should see the link for viewing and I visit it
    Then I should see the list for the filtered country
    Then I should see the list for the filtered weo subject codes
    Then I should see the list for the filtered country list

