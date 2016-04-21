Given(/^I am a visitor$/) do
  @user = FactoryGirl.create(:visitor)
  @record = FactoryGirl.create(:country_data)
end

When(/^I visit the main page$/) do
  visit '/'
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

Then(/^I visit View in Charts$/) do
  visit '/search/index'
end

Then(/^I see Select Country$/) do
 expect(page).to have_content ('Select Country')
end

Then(/^I see Select Subject$/) do
 expect(page).to have_content ('Select subjects')
end

Then(/^I see Select Year Range$/) do
  expect(page).to have_content ('Select year range')
end

Then(/^I should see a Search button$/) do
  expect(page).to have_button ('Search')

end

Then(/^I should click on the Search button$/) do
  find(:xpath, "//input[@id='amount']").set "1990,1995"
  check 'country_list[country_name][]'
  check 'subject_list[subject_name][]'
  click_button 'Search'
end

Then(/^I see the charts$/) do

  visit '/search/index?utf8=&country_list[country_name][]=Afghanistan&country_list[country_name][]=&subject_list[subject_name][]=Current+account+balance&subject_list[subject_name][]=&amount=1990%2C2000'
end

