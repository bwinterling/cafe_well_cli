gem 'minitest', '~> 4.2'
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara'
require_relative 'cafe_well_cli'

class CafeWellCLITest < MiniTest::Unit::TestCase

  def setup
    @cafe_well = CafeWellCLI.new
  end

  def cafe_well
    @cafe_well
  end

  def test_reach_cafe_well_home_page?
    cafe_well.go_to_home_page
    assert cafe_well.at_home_page?
    refute cafe_well.logged_in?
  end

  def test_log_in
    cafe_well.go_to_home_page
    refute cafe_well.logged_in?
    cafe_well.log_in
    assert cafe_well.logged_in?
  end

end
