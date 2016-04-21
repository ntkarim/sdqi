Then(/^I go to View in Tables$/) do
  visit '/search/table'
end

Then(/^I see filtered page$/) do
  visit '/search/table?utf8=&country_list[country_name][]=Afghanistan&country_list[country_name][]=&subject_list[subject_name][]=Current+account+balance&subject_list[subject_name][]=&amount=1994%2C1996'
end

Then(/^I see export$/) do
  click_button 'Export in excel'
end