Given(/^I am registered user$/) do
  @user = FactoryGirl.create(:visitor)
end

Given(/^I am logged in as the user$/) do
  visit '/users/sign_in'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

Then(/^I should see the link for viewing visualizations$/) do
  page.should have_selector(:link_or_button, 'View Data in Table')
end

Then(/^I visit it$/) do
  find_link('View Data in Tables', href: "/search/index").click
end

Then(/^I select some countries and select for visualization$/) do
  visit('?utf8&country_list[country_name][]=Nepal&country_list[country_name][]=&subject_list[subject_name][]=Employment&subject_list[subject_name][]=&amount=1990%2C2000')
end

Then(/^I should see the visualizations$/) do
  has_xpath?("//rect")
end

And(/^I should see the items in tabular view$/)do
has_xpath?("//td")
end
