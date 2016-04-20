FactoryGirl.define do
  factory :visitor, class: User do
    email "visitor@ait.asia"
    password "password"
    password_confirmation "password"
  end
  factory :country_data, class: Search do
    weo_country_code "512"
    iso "AFG"
    weo_subject_code "NGDP R"
    country "Afghanistan"
    subject_descriptor "Gross"
    subject_notes "sth"
    units "Index"
    scale "Units"
    country_series_notes "sth2"
    data_1989 "10"
    data_1990 "10"
    data_1991 "10"
    data_1992 "10"
    data_1993 "10"
    data_1994 "10"
    data_1995 "10"
    data_1996 "10"
    data_1997 "10"
    data_1998 "10"
    data_1999 "10"
    data_2000 "10"
    data_2001 "10"
    estimate_start_after "2013"
  end 
end
