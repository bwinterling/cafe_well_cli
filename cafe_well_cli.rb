require 'rubygems'
require 'mechanize'
require 'thor'
require 'pry'

class CafeWellCLI < Thor

  desc 'add_activity ACTIVITY_ID MINUTES "DATE"', 'new MoveToImprove entry for CafeWell.'
  long_desc <<-LONGDESC
    >$ cafe_well_cli.rb add_activity 49 30 "mm/dd/yyyy"

    ACTIVITY_ID => the ID for Walking is 49
      To look up activities and IDs, use command 'activity_list'
    MINUTES => I walked for 30 minutes
    DATE param is optional, and will default to today if blank.

    This updates CafeWell's Move to Improve data.
    Make sure so sign up in advance.
  LONGDESC
  def add_activity(activity_id, minutes, date = today)
    return "Invalid Date" unless valid?(date)
    go_to_cafe_well
    log_in unless logged_in?
    activity_form = current_page.form_with(:action => "/activity_entries/create_activity") do |form|
      form.field_with(:name => "activity_entry[performed_at]").value = euro_date(date)
      form.field_with(:name => "activity_entry[activity_id]").value = activity_id
      form.field_with(:name => "activity_entry[activity_unit_value]").value = minutes
    end
    begin
      results_page = activity_form.submit
      results = results_page.body
      puts "Added activity."
    rescue Exception => msg
      results = "Invalid entry: " + msg.to_s
      puts results
    end
    @current_page = go_to_cafe_well
    results
  end

  desc "activity_list", "List of activities and their IDs."
  def activity_list
    go_to_cafe_well
    log_in unless logged_in?
    activity_form = current_page.form_with(:action => "/activity_entries/create_activity")
    select_list = activity_form.field_with(:name => "activity_entry[activity_id]")
    @activities = select_list.options.each_with_object(Hash.new) do |option, list|
      list[option.text] = option.value
    end
    puts "ID ------- Activity"
    puts "-------------------"
    @activities.each { |name, id| puts id + " -- " + name }
  end

  # no_tasks removes public methods from the CLI
  no_tasks do

    def activities
      activity_list unless @activities
      @activities
    end

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
      Date.today.strftime("%m/%d/%Y")
    end

    def valid?(date)
      date.match(/^[0-1]{1}\d{1}[\/]{1}\d{2}[\/]{1}\d{4}/)
    end

    # day and month need to be switched for CafeWell form entry
    def euro_date(date)
      date_parts = date.split("/")
      "#{date_parts[1]}/#{date_parts[0]}/#{date_parts[2]}"
    end

  end

end
# start() method makes the public methods available in the cli via Thor
# CafeWellCLI.start()
