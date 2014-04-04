# cafe_well_cli

Many companies offer insurance incentives using CafeWell.  The intent of this
CLI is to make entering your acheivements simple, so you don't leave cash
on the table.

Before you can use this gem, be sure to create an account at [www.cafewell.com](http://www.cafewell.com/ "CafeWell")

## Installation

    $ gem install cafe_well_cli

Be sure to add your CafeWell.com username and password as environment variables.
``` .bashrc
export CAFEWELL_USER="your_username"
export CAFEWELL_PASSWORD="your_password"
```

## Usage

Here's how you make your entries:

**Activity List** You'll need the ACTIVITY_ID of your activity to make an entry.
``` console
    $ bin/cafewell activity_list
```
**Add Activity** So, you played 30 minutes of ping pong.  After using the above command, you determined that 28 is the ACTIVITY_ID for ping pong.

Write your command like so: add_activity ID MINUTES ["DATE"]

**Note:** DATE is optional, and must be "mm/dd/yyyy" format.  Defaults to today if blank.
``` console
    $ bin/cafewell add_activity 28 30 "03/28/2014"
    - or -
    $ bin/cafewell add_activity 28 30
```


## Contributing

1. Fork it (click the fork button up top)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
