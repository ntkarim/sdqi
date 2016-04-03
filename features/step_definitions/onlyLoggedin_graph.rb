Given(/^I am a visitor$/) do
  @user = FactoryGirl.create(:visitor)
end

When(/^I visit the main page$/) do
  visit '/'
end

Then(/^I should not see a link for Statistical View$/) do
  #page.should have_no_content('STATISTICAL VIEW')
  page.should have_no_selector(:link_or_button, 'Statistical View')
end

When(/^I am signed in$/) do
  visit '/users/sign_in'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

Then(/^I should see a link for Stastical View$/) do
  page.should have_selector(:link_or_button, 'Statistical View')
end
