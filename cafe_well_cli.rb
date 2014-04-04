require 'rubygems'
require 'mechanize'
require 'thor'
require 'pry'

class CafeWellCLI < Thor

  desc 'activity_list', 'List of activities and their IDs.'
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

  desc 'add_activity ACTIVITY_ID MINUTES ["DATE"]', 'new MoveToImprove entry for CafeWell.'
  long_desc <<-LONGDESC
    >$ cafe_well_cli.rb add_activity 49 30 "mm/dd/yyyy"

    ACTIVITY_ID => the ID for Walking is 49
      To look up activities and IDs, use command 'activity_list'
    MINUTES => I walked for 30 minutes
    DATE param is optional, and will default to today if blank

    This updates CafeWell's Move to Improve data
    Make sure to sign up in advance at www.cafewell.com
    Set up your username and password as ENV variables
    CAFEWELL_USER & CAFEWELL_PASSWORD
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

  desc 'add_meals MEAL_COUNT ["DATE"]', 'new Food Swap Challenge entry for CafeWell'
  long_desc <<-LONGDESC
    >$ cafe_well_cli.rb add_meals MEAL_COUNT "mm/dd/yyyy"

    MEAL_COUNT => total healthy meals for the day
    DATE param is optional, and will default to today if blank

    This updates CafeWell's Food Swap Challenge
    Make sure to sign up in advance at www.cafewell.com
    Set up your username and password as ENV variables
    CAFEWELL_USER & CAFEWELL_PASSWORD
    Food Swap Challenge (ends 6/30/2014)
  LONGDESC
  def add_meals(meal_count, date = today)
    return "Invalid Date" unless valid?(date)
    go_to_cafe_well
    log_in unless logged_in?
    meal_form = current_page.form_with(:action => "/challenges/food-swap-challenge/post_progress") do |form|
      form.field_with(:name => "user_challenge_progress[activity_date]").value = euro_date(date)
      form.field_with(:name => "user_challenge_progress[reported_value]").value = meal_count
    end
    begin
      results_page = meal_form.submit
      results = results_page.body
      puts "Added meals."
    rescue Exception => msg
      results = "Invalid entry: " + msg.to_s
      puts results
    end
    @current_page = go_to_cafe_well
    results
  end

  desc 'add_break ["DATE"]', 'new Stress Break entry for CafeWell'
  long_desc <<-LONGDESC
    >$ cafe_well_cli.rb add_break "mm/dd/yyyy"

    DATE param is optional, and will default to today if blank

    This adds a Stress Break to CafeWell's Stress Management plan
    Make sure to sign up in advance at www.cafewell.com
    Set up your username and password as ENV variables
    CAFEWELL_USER & CAFEWELL_PASSWORD
    Stress Break (ends 4/30/2014)
  LONGDESC
  def add_break(date = today)
    return "Invalid Date" unless valid?(date)
    go_to_cafe_well
    log_in unless logged_in?
    break_form = current_page.form_with(:action => "/challenges/stress-break/post_progress") do |form|
      form.field_with(:name => "user_challenge_progress[activity_date]").value = euro_date(date)
      form.field_with(:name => "user_challenge_progress[reported_value]").value = 1
    end
    begin
      results_page = break_form.submit
      results = results_page.body
      puts "Added break."
    rescue Exception => msg
      results = "Invalid entry: " + msg.to_s
      puts results
    end
    @current_page = go_to_cafe_well
    results
  end

  desc 'met_family_goal ["DATE"]', 'new Family Goal entry for CafeWell'
  def met_family_goal(date = today)
    return "Invalid Date" unless valid?(date)
    go_to_cafe_well
    log_in unless logged_in?
    family_goal_form = current_page.form_with(:action => "/challenges/5210-campaign/post_progress") do |form|
      form.field_with(:name => "user_challenge_progress[activity_date]").value = euro_date(date)
      form.field_with(:name => "user_challenge_progress[reported_value]").value = 1
    end
    begin
      results_page = family_goal_form.submit
      results = results_page.body
      puts "Added family goal day."
    rescue Exception => msg
      results = "Invalid entry: " + msg.to_s
      puts results
    end
    @current_page = go_to_cafe_well
    results
  end

  desc "info", "Explains the CafeWell incentives"
  def info
    puts <<-INFO
      Move To Improve:
        Earn up to $300
        For every minute of exercise, you earn a point
        First 2,000 points = $25
        Each 1,000 points after is another $25

      Healthy Eating:  Food Swap Challenge (ends 6/30/2014)
        Earn up to $300
        Enter how many healthy meals you ate that day (max 6)
        Every healthy meal earns a point
        First 130 points = $25
        Each 60 points after is another $25

      Stress Break: (ends 4/30/2014)
        Earn up to $150
        Report one stress break every day you take a 10 minute break
        Only receive credit for one break per day

      Family Activity: 5210 Campaign (ends 6/30/2014)
        Earn up to $100
        Daily Goal:
          5 or more fruits or vegetables
          2 hours or fewer screen time after work/school
          1 hour or more exercise
          0 sugary drinks
        Report one successful Campaign Day when the majority of
        your family members meet this goal
    INFO
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
