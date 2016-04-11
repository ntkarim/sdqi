Given(/^I am registered member$/) do
  @user = FactoryGirl.create(:visitor)
end

Given(/^I am logged in as the member$/) do
  visit '/users/sign_in'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

Then(/^I should see the link for viewing I visit it$/) do
  page.should have_selector(:link_or_button, 'View Data in Table')
end

Then(/^I should not see any of the visualization techniques since I do not have any country selected$/) do
  has_no_xpath?("//rect")
end
