# cafe_well_cli

Many companies offer insurance incentives using CafeWell.  The intent of this
CLI is to make entering your acheivements simple, so you don't leave cash
on the table.

Before you can use this gem, be sure to create an account at [www.cafewell.com](http://www.cafewell.com/ "CafeWell") and sign up for the various campaigns.  If you haven't joined the campaigns, this CLI will not work.  Sad face.

## Installation

    $ gem install cafe_well_cli

Be sure to add your CafeWell.com username and password as environment variables.
``` .bashrc
export CAFEWELL_USER="your_username"
export CAFEWELL_PASSWORD="your_password"
```

## Usage

Here's how you make your entries:

**Activity List** (all of 2014)

You'll need the ACTIVITY_ID of your activity to make an entry.
``` console
    $ cafewell activity_list
```
**Add Activity** So, you played 30 minutes of ping pong.  After using the above command, you determined that 28 is the ACTIVITY_ID for ping pong.

Write your command like so:  add_activity ID MINUTES ["DATE"]

**Note:** DATE is optional, and must be "mm/dd/yyyy" format.  Defaults to today if blank.
``` console
    $ cafewell add_activity 28 30 "03/28/2014"
    - or -
    $ cafewell add_activity 28 30
```

**Add Meals** (ends 6/30/2014)

You can enter up to 6 healthy meals a day.  Don't be shy.  Let's say you ate four healthy meals.

add_meals MEAL_COUNT ["DATE"]

**Note:** DATE is optional, and must be "mm/dd/yyyy" format.  Defaults to today if blank.
``` console
    $ cafewell add_meals 4 "03/28/2014"
    - or -
    $ cafewell add_meals 4
```

**Add Stress Breaks** (ends 4/30/2014)

You can add a 'Stress Break' if you took a 10 minute break from your daily grind.  Only 1 per day is accepted, so I've locked it down to prevent you from being a total slacker.

add_break ["DATE"]

**Note:** DATE is optional, and must be "mm/dd/yyyy" format.  Defaults to today if blank.
``` console
    $ cafewell add_break "03/28/2014"
    - or -
    $ cafewell add_break
```

**Add Family Goal** (ends 6/30/2014)

This one's tough.  Each member of your family must eat 5 or more servings of fruit or veggies, complete 1 or more hours of exercise, consume 0 sugary drinks and log fewer than 2 hours of after work/school screen time.  No cheating.  Pull it off?  Run the following command:

met_family_goal ["DATE"]

**Note:** DATE is optional, and must be "mm/dd/yyyy" format.  Defaults to today if blank.
``` console
    $ cafewell met_family_goal "03/28/2014"
    - or -
    $ cafewell met_family_goal
```

## Contributing

1. Fork it (click the fork button up top)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
