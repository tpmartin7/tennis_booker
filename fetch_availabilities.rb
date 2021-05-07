#!/usr/bin/env ruby

=begin

By inspecting the network traffic with Chrome Developer Tools on this page:
https://www.towerhamletstennis.org.uk/bethnal-green-gardens

I found that the following POST request (try in terminal):

`curl -X POST https://uk.bookingbug.com/book/top_item_choose?sel_day=2459345&amp;start=2459342&amp;wid=4392254`

fetches an HTML table with court availabilities for the week commencing May 10th 2021.
In the URL query, `start` and `wid` always have the same values. 
The only thing that changes is the `sel_day` value. 

The value of `2459345` for sal_day fetches the schedule for the week commencing May 10th 2021. 
To request for the next week (May 17th), increment the value by 7:

`curl -X POST https://uk.bookingbug.com/book/top_item_choose?sel_day=2459352&amp;start=2459342&amp;wid=4392254`

Below is a Ruby implementation that increments the `sal_day` value according
to user input and fetches the HTML content with availabilities.

Usage example: Fetch availabilities for the week commencing 17th May 2021:

`ruby fetch_availabilities.rb 2021-05-17`

I think it only works for the current week and the following two weeks.

=end

require 'net/http'
require 'date'

# Need some reference point, using May 10th 2021 
START_DATE = '2021-05-10'
START_DATE_VALUE = 2459345


input_date = ARGV[0]
diff_days = (Date.parse(input_date) - Date.parse(START_DATE)).to_i

# Validation
if diff_days < 0
	puts "Date must be #{START_DATE} or later"
	return 
elsif diff_days % 7 != 0
	puts 'Date must be a Monday'
	return
end	

uri = URI("https://uk.bookingbug.com/book/top_item_choose?sel_day=#{START_DATE_VALUE + diff_days}&amp;start=2459342&amp;wid=4392254")
res = Net::HTTP.post(uri, '')
puts res.body
