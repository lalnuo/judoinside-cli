#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

def print_competitions(judoka_page)
  competitions = judoka_page.css('.accord').map do |competition|
    name = competition.children.first.text
    medals = (1..3).map { |i| competition.children[i].text }
    printf("%-35s %d %d %d\n", name, medals[0], medals[1], medals[2])
  end
end

def print_judoka(judoka)
  name = judoka.css('h2').text
  country = judoka.css('#judokaUserDatas').css('li')[0].text.split(':').last
  age = judoka.css('#judokaUserDatas').css('li')[1].text.split(':').last
  puts "Name: #{name}
  Born: #{age}
  Country: #{country}"

end

def judoka_page_for(judoka_name)
  page = Nokogiri::HTML(open("http://judoinside.com/site/search?q=#{judoka_name}"))
  first = page.css('a').find { |a| a.to_s.match(/\/judoka\/[0-9]/) }
  Nokogiri::HTML(open("http://judoinside.com/#{first.attributes['href']}"))
end

judoka_name = ARGV.join('+')
judoka_page = judoka_page_for(judoka_name)
print_judoka(judoka_page)
print_competitions(judoka_page)
