Given(/^I am a guest$/) do
  @user = FactoryGirl.create(:visitor)
  @record = FactoryGirl.create(:country_data)
end

Then(/^I do not see export$/) do
  expect(page).to have_no_button('Export in excel')
end

