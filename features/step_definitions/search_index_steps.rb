Given(/^I am a member$/) do
  @user = FactoryGirl.create(:visitor)
end

Given(/^I am logged in as a member$/) do
  visit '/users/sign_in'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

Then(/^I should see the link for viewing$/) do
  page.should have_selector(:link_or_button, 'Statistical View')
end

When(/^I click on the link for viewing$/) do
  visit '/search/index'
end

Then(/^I should see the page for viewing tables$/) do
  expect(page).to have_content "#{@country_list}"
end


