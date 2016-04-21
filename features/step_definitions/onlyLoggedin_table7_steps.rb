Given(/^I am a visitor to choose four countries and three subjects$/) do
  @user = FactoryGirl.create(:visitor)
  @record = FactoryGirl.create(:country_data)
  @record1 = FactoryGirl.create(:country_data1)
  @record2 = FactoryGirl.create(:country_data2)
  @record3 = FactoryGirl.create(:country_data3)
  @record4 = FactoryGirl.create(:country_data4)
  @record5 = FactoryGirl.create(:country_data5)
  @record6 = FactoryGirl.create(:country_data6)
  @record7 = FactoryGirl.create(:country_data7)
  @record8 = FactoryGirl.create(:country_data8)
  @record9 = FactoryGirl.create(:country_data9)
  @record10 = FactoryGirl.create(:country_data10)
  @record11 = FactoryGirl.create(:country_data11)
end

Then(/^I should click on the Search button for four countries and three subjects$/) do
  find(:xpath, "//input[@id='amount']").set "1990,1995"
  find(:css, "#country_list_country_name_afghanistan[value='Afghanistan']").set(true)
  find(:css, "#country_list_country_name_bangladesh[value='Bangladesh']").set(true)
  find(:css, "#country_list_country_name_thailand[value='Thailand']").set(true)
  find(:css, "#country_list_country_name_nepal[value='Nepal']").set(true)
  find(:css, "#subject_list_subject_name_gross[value='Gross']").set(true)
  find(:css, "#subject_list_subject_name_income[value='Income']").set(true)
  find(:css, "#subject_list_subject_name_population[value='Population']").set(true)
  click_button 'Search'
end
