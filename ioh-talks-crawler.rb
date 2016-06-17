require 'nokogiri'
require 'pry'
require 'json'
require 'open-uri'

talks = []

home = "http://ioh.tw"

url = 'http://ioh.tw/talks'
doc = Nokogiri::HTML(open(url))

# page = "http://ioh.tw/talks/page/#{num}"
# IOH got talk pages 2 ~ 30, update to 2016 / 06 / 17 (Fri)


# Dir.glob('http://ioh.tw/talks').each do |filename|
  # str = File.read(filename)
  # doc = Nokogiri::HTML(str.encode("utf-8", :invalid => :replace, :undef => :replace))

doc.css('div#main div.row-fluid article').each do |talks_info|

  talks << {
    url: "#{home}" + talks_info.css('a')[0][:href],
    name: talks_info.css('h4/a')[0].text,
    avatar: talks_info.css('a/img')[0]['src'],
    school: [talks_info.css('div.schools/a')[0].text, talks_info.css('div.schools/a')[1].text],
    department: talks_info.css('.category/a')[0].text,
    description: talks_info.css('p')[0].text.gsub("\n",''),
  }

end

(2..30).each do |num|

  page = "http://ioh.tw/talks/page/#{num}"
  doc_page = Nokogiri::HTML(open(page))

  doc_page.css('div#main div.row-fluid article').each do |talks_info|

    data = {
      url: "#{home}" + talks_info.css('a')[0][:href],
      name: talks_info.css('h4/a')[0].text,
      avatar: talks_info.css('a/img')[0]['src'],
      # school: [talks_info.css('div.schools/a')[0].text, talks_info.css('div.schools/a')[1].text],
      department: talks_info.css('.category/a')[0].text,
      description: talks_info.css('p')[0].text.gsub("\n",''),
    }

    if talks_info.css('div.schools/a')[1] != nil
      data[:school] = [talks_info.css('div.schools/a')[0].text, talks_info.css('div.schools/a')[1].text]
    else
      data[:school] = [talks_info.css('div.schools/a')[0].text]
    end 

    talks << data

  end

end


File.open('ioh-talks-for-ncnu.json', 'w') {|file| file.write(JSON.pretty_generate(talks))}
