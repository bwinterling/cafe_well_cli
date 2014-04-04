gem 'minitest', '~> 4.2'
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara'
require_relative 'cafe_well_cli'

class CafeWellCLITest < MiniTest::Unit::TestCase

  # before running tests - comment out line "CafeWellCLI.start()"
  # you need to have a username and password set up as environment variables

  def setup
    @cafe_well = CafeWellCLI.new
  end

  def cafe_well
    @cafe_well
  end

  def test_reach_cafe_well_home_page?
    cafe_well.go_to_cafe_well
    assert cafe_well.at_home_page?
  end

  def test_log_in
    skip
    refute cafe_well.logged_in?
    cafe_well.log_in
    assert cafe_well.logged_in?
  end

  def test_valid_date
    date = "31/04/2014"
    refute cafe_well.valid?(date)
    date = "4/25/2014"
    refute cafe_well.valid?(date)
    date = "04/12/14"
    refute cafe_well.valid?(date)
    date = "04-23-2014"
    refute cafe_well.valid?(date)
    date = "04/28/2014"
    assert cafe_well.valid?(date)
  end

  def test_date_conversion
    date = "04/25/2014"
    assert_equal "25/04/2014", cafe_well.euro_date(date)
  end

  def test_activity_entry
    # skip
    activity = 10
    minutes = 30
    date = "04/03/2014"
    results = "{\"last_progress_info\":\"<p>Last logged\\n<strong>30</strong>\\nminutes of\\nCooking\\nfor\\n<strong>Apr 3, 2014 at 12:00 AM MDT</strong>\\n<a href=\\\"/tracks/move-to-Improve-aetna\\\">View Track log</a>\\n</p>\\n\"}"
    assert_equal results, cafe_well.add_activity(activity, minutes, date)
  end

  def test_invalid_activity_ID_entry
    skip
    activity = 900
    minutes = 13
    date = "04/04/2014"
    results = "{\"last_progress_info\":\"<p>Last logged\\n<strong>15</strong>\\nminutes of\\nWalking\\nfor\\n<strong>Apr 4, 2014 at 12:00 AM MDT</strong>\\n<a href=\\\"/tracks/move-to-Improve-aetna\\\">View Track log</a>\\n</p>\\n\"}"
    assert cafe_well.add_activity(activity, minutes, date).start_with?("Invalid")
  end

  def test_meal_entry
    skip
    date = "04/02/2014"
    meals = 4
    refute cafe_well.add_meals(meals, date).start_with?("Invalid")
  end

  def test_break_entry
    skip
    date = "04/02/2014"
    refute cafe_well.add_break(date).start_with?("Invalid")
  end

  def test_family_goal_entry
    skip
    date = "04/01/2014"
    refute cafe_well.met_family_goal(date).start_with?("Invalid")
  end

end
