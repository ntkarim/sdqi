Given(/^I am a registered member$/) do
  @user = FactoryGirl.create(:visitor)
end

Given(/^I am logged in as a the member$/) do
  visit '/users/sign_in'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

Then(/^I should see the link for viewing and I visit it$/) do
  page.should have_selector(:link_or_button, 'View Data in Table')end

Then(/^I should see the page for viewing tables $/) do
  visit ('/search/index')
end

Then(/^I should see the list for the filtered country$/) do
#visit('search/index/?utf8&year1=1980&year2=1980&commit=Search&country_list[Afganistan][]=&subject_list[subject_name][]=')
  #expect(page).should_not have_content "Email:#{@admin.email}"
  has_no_xpath?("//tr")
end

Then(/^I should see the list for the filtered weo subject codes$/) do
  visit('?utf8&year1=1980&year2=1980&commit=Search&country_list%5Bcountry_name%5D%5B%5D=&subject_list%5Bsubject_name%5D%5B%5D=Employment&subject_list%5Bsubject_name%5D%5B%5D=')
end

Then(/^I should see the list for the filtered country list$/) do
  visit('?utf8&year1=1980&year2=1985&commit=Search&country_list%5Bcountry_name%5D%5B%5D=United+States&country_list%5Bcountry_name%5D%5B%5D=&subject_list%5Bsubject_name%5D%5B%5D=Employment&subject_list%5Bsubject_name%5D%5B%5D=')
end
