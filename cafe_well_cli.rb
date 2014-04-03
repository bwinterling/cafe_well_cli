require 'rubygems'
require 'mechanize'
require 'thor'
require 'pry'

class CafeWellCLI < Thor

  desc "update_move_to_improve DATE ACTIVITY MINUTES", "updates cafe well with activity activity details"
  long_desc <<-LONGDESC
    >$ cafe_well_cli.rb update_move_to_improve "04/31/2014" "Walking" "30"

    will update Cafe Well with the entered activity.

  LONGDESC
  def update_move_to_improve(date, activity, minutes)
    puts "#{ENV["CAFEWELL_USER"]} did a little #{activity} for #{minutes} mins on #{date}."
    #logged in?
      # no
        # log in
      # yes
        # enter date (enter value or use date picker)
        # enter activity (select list)
        # enter minutes (value)
        # click 'Report'
  end

  # no_tasks removes public methods from the CLI
  no_tasks do

    def agent
      @agent ||= Mechanize.new
    end

    def go_to_cafe_well
      @current_page = agent.get('http://www.cafewell.com')
    end

    def current_page
      @current_page
    end

    def current_page=(page)
      @current_page = page
    end

    def at_home_page?
      #does this work?
      current_page.title == "\nCaféWell\n\n"
    end

    def logged_in?
      current_page.form_with(:id => "user_login_form") == nil
    end

    def log_in
      #add logic to handle multiple cases

      login_form = current_page.form_with(:id => "user_login_form") do |form|
        form.field_with(:name => "user[login]").value = ENV["CAFEWELL_USER"]
        form.field_with(:name => "user[password]").value = ENV["CAFEWELL_PASSWORD"]
      end

      @current_page = login_form.submit
    end

  end

end
# start() method makes the public methods available in the cli via Thor
# CafeWellCLI.start()
