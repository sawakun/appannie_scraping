# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
# CSV
require 'csv'

# スクレイピング先のURL
# iOS AppStore
base_url = 'http://www.appannie.com/apps/ios/top/japan/'

device_list = ["iphone", "ipad"]
category_list = ["education", "kids"]
kids_list = ["ages-5-under", "ages-6-8", "ages-9-11"] 

def print_in_csv(hash_array)
  print "#,", CSV.generate_line(hash_array[0].keys)
  i=1
  hash_array.each do |hash|
    print i,",", CSV.generate_line(hash.values)
    i+=1
  end
end

device_list.each do |device|
  category_list.each do |category|

    url = base_url + category + "/?device=" + device
    p url
    begin
      # User-agentを設定しないとアクセスできない
      doc = Nokogiri::HTML(open(url, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36"),nil,"utf-8")
    rescue
      p "page not found"
    else
      result=[]
      doc.css("#storestats-top-table").css('tr').each do |row|
        items = row.search(".item-info")
        result.push({"free_title"=>items[0].search(".title-info").text.strip,
                  "free_publisher"=> items[0].search(".add-info").text.strip,
                  "paid_title"=>items[1].search(".title-info").text.strip,
                  "paid_publisher"=> items[1].search(".add-info").text.strip,
                  "sales_title"=>items[2].search(".title-info").text.strip,
                  "sales_publisher"=> items[2].search(".add-info").text.strip})
      end
      print_in_csv(result)

    ensure
      print "\n"
    end
  end
end

