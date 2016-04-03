class CreateDatabaseStructure < ActiveRecord::Migration
  def change
    # encoding: UTF-8
    # This file is auto-generated from the current state of the database. Instead
    # of editing this file, please use the migrations feature of Active Record to
    # incrementally modify your database, and then regenerate this schema definition.
    #
    # Note that this schema.rb definition is the authoritative source for your
    # database schema. If you need to create the application database on another
    # system, you should be using db:schema:load, not running all the migrations
    # from scratch. The latter is a flawed and unsustainable approach (the more migrations
    # you'll amass, the slower it'll run and the greater likelihood for issues).
    #
    # It's strongly recommended that you check this file into your version control system.

    ActiveRecord::Schema.define(version: 0) do

      # These are extensions that must be enabled in order to support this database
      enable_extension "plpgsql"

      create_table "country_data", id: false, force: :cascade do |t|
        t.string "weo_country_code",     limit: 5
        t.string "iso",                  limit: 3
        t.string "weo_subject_code",     limit: 50
        t.string "country",              limit: 50
        t.string "subject_descriptor",   limit: 100
        t.text   "subject_notes"
        t.string "units",                limit: 50
        t.string "scale",                limit: 50
        t.text   "country_series_notes"
        t.text   "data_1980"
        t.text   "data_1981"
        t.text   "data_1982"
        t.text   "data_1983"
        t.text   "data_1984"
        t.text   "data_1985"
        t.text   "data_1986"
        t.text   "data_1987"
        t.text   "data_1988"
        t.text   "data_1989"
        t.text   "data_1990"
        t.text   "data_1991"
        t.text   "data_1992"
        t.text   "data_1993"
        t.text   "data_1994"
        t.text   "data_1995"
        t.text   "data_1996"
        t.text   "data_1997"
        t.text   "data_1998"
        t.text   "data_1999"
        t.text   "data_2000"
        t.text   "data_2001"
        t.text   "data_2002"
        t.text   "data_2003"
        t.text   "data_2004"
        t.text   "data_2005"
        t.text   "data_2006"
        t.text   "data_2007"
        t.text   "data_2008"
        t.text   "data_2009"
        t.text   "data_2010"
        t.text   "data_2011"
        t.text   "data_2012"
        t.text   "data_2013"
        t.text   "data_2014"
        t.text   "data_2015"
        t.text   "data_2016"
        t.text   "data_2017"
        t.text   "data_2018"
        t.text   "data_2019"
        t.text   "data_2020"
        t.string "estimate_start_after", limit: 10
      end

    end

    create_table :database_structures do |t|
    end
  end
end
