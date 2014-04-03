require 'rubygems'
require 'mechanize'
require 'thor'
require 'pry'

class CafeWellCLI < Thor

  desc "update_move_to_improve ACTIVITY_ID MINUTES <DATE>", "updates cafe well with activity activity details, DATE is optional"
  long_desc <<-LONGDESC
    >$ cafe_well_cli.rb update_move_to_improve "Walking" "30" "31/04/2014"

    Will update Cafe Well with the entered activity.
    DATE param is optional, and will default to today.
    For a list of activities, enter 'activity_list'.
  LONGDESC
  def update_move_to_improve(activity_id, minutes, date = today)
    # puts "#{ENV["CAFEWELL_USER"]} did a little #{activity} for #{minutes} mins on #{date}."
    go_to_cafe_well
    log_in unless logged_in?
    activity_form = current_page.form_with(:action => "/activity_entries/create_activity") do |form|
      # should verify correct values have been entered
      # date format is d/m/Y
      form.field_with(:name => "activity_entry[performed_at]").value = date
      form.field_with(:name => "activity_entry[activity_id]").value = activity_id
      form.field_with(:name => "activity_entry[activity_unit_value]").value = minutes
    end
    results_page = activity_form.submit
    @current_page = go_to_cafe_well
    results_page.body
  end

  desc "activity_list", "List of activities and their IDs."
  def activity_list
    go_to_cafe_well
    log_in unless logged_in?
    activity_form = current_page.form_with(:action => "/activity_entries/create_activity")
    select_list = activity_form.field_with(:name => "activity_entry[activity_id]")
    select_list.options.each_with_object(Hash.new) do |option, list|
      list[option.text] = option.value
    end
  end

  # no_tasks removes public methods from the CLI
  no_tasks do

    def agent
      @agent ||= Mechanize.new
    end

    def cafe_well_uri
      'http://www.cafewell.com'
    end

    def go_to_cafe_well
      @current_page = agent.get(cafe_well_uri)
    end

    def current_page
      @current_page
    end

    def at_home_page?
      current_page.title == "\nCaféWell\n\n"
    end

    def logged_in?
      go_to_cafe_well if current_page == nil
      current_page.form_with(:id => "user_login_form") == nil
    end

    def log_in
      go_to_cafe_well
      login_form = current_page.form_with(:id => "user_login_form") do |form|
        form.field_with(:name => "user[login]").value = ENV["CAFEWELL_USER"]
        form.field_with(:name => "user[password]").value = ENV["CAFEWELL_PASSWORD"]
      end
      @current_page = login_form.submit
    end

    def today
      Date.today.strftime("%d/%m/%Y")
    end

  end

end
# start() method makes the public methods available in the cli via Thor
# CafeWellCLI.start()
