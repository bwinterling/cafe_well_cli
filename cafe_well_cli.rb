require 'rubygems'
require 'mechanize'
require 'thor'

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

  no_tasks do
    def go_to_home_page

    end
  end

end

# CafeWellCLI.start()
