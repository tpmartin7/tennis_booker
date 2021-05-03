require 'nokogiri'
require 'open-uri'

sample_url_bethnal_green = "https://uk.bookingbug.com/book/all?height=470&id=w981356&iframe=bb_all_ukw981356_4207f&palette=THT+BR&service=24373&style=medium-small&width=980&category="

class TableParser
  # def initialize(table_url)
  #   @table_url = table_url
  # end

  def self.parse_local(file_path)
    nok_doc = Nokogiri::HTML(File.open(file_path))
    dis_count = nok_doc.search(".dis").size
    booked_count = nok_doc.search(".booked").size
    en_count = nok_doc.search('.en').size

    puts "dis : #{dis_count}\nbooked : #{booked_count}"

    prices = nok_doc.search('.en').map do |node|
      next_price = node.text
      next_price[0] = ''
      next_price
    end

    print "en : #{en_count}\nprices : "

    p prices
    # I think this screenshot was taken before the 8 o clock booking slot was released.
    # there are 7 cells with class 'dis' but only 6 with 'dis booked'
    # class 'dis' without 'booked' means a slot yet to be released.
    # class 'en' is a clickable booking link. the text of this element (div?) is the price.
  end
end

# test
TableParser.parse_local('lib/bethnal_sample.html')
