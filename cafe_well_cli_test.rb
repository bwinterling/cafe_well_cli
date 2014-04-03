gem 'minitest', '~> 4.2'
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara'
require_relative 'cafe_well_cli'

class CafeWellCLITest < MiniTest::Unit::TestCase

  #before running tests - comment out line "CafeWellCLI.start()"

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

  def test_activity_entry
    activity = 49
    minutes = 20
    date = "31/03/2014"
    results = "{\"last_progress_info\":\"<p>Last logged\\n<strong>20</strong>\\nminutes of\\nWalking\\nfor\\n<strong>Mar 31, 2014 at 12:00 AM MDT</strong>\\n<a href=\\\"/tracks/move-to-Improve-aetna\\\">View Track log</a>\\n</p>\\n\"}"
    assert results, cafe_well.update_move_to_improve(activity, minutes, date)
  end

end
