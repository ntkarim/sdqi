Given(/^I am a visitor to choose two countries$/) do
  @user = FactoryGirl.create(:visitor)
  @record = FactoryGirl.create(:country_data)
  @record1 = FactoryGirl.create(:country_data1)
end

Then(/^I should click on the Search button for two countries$/) do
  find(:xpath, "//input[@id='amount']").set "1990,1995"
  find(:css, "#country_list_country_name_afghanistan[value='Afghanistan']").set(true)
  find(:css, "#country_list_country_name_bangladesh[value='Bangladesh']").set(true)
  check 'subject_list[subject_name][]'
  click_button 'Search'
end