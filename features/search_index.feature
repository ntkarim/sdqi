Feature: SearchIndex

  To check if the member can visit the index page for table view of the countries

  Scenario: After a user if logged in, then s/he can see the tablular view along with country list

    Given I am a member
    And I am logged in as a member
    Then I should see the link for viewing
    When I click on the link for viewing
    Then I should see the page for viewing tables

