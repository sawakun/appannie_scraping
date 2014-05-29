# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
# CSV
require 'csv'

# スクレイピング先のURL
# Google Play
base_url = 'http://www.appannie.com/apps/google-play/top/japan/application/education/'

def print_in_csv(hash_array)
  print "#,", CSV.generate_line(hash_array[0].keys)
  i=1
  hash_array.each do |hash|
    print i,",", CSV.generate_line(hash.values)
    i+=1
  end
end

url = base_url
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

    if items.size < 4 then
      result.push({
        "free_title"=>items[0].search(".title-info").text.strip,
        "free_publisher"=> items[0].search(".add-info").text.strip,
        "paid_title"=>items[1].search(".title-info").text.strip,
        "paid_publisher"=> items[1].search(".add-info").text.strip,
        "sales_title"=>items[2].search(".title-info").text.strip,
        "sales_publisher"=> items[2].search(".add-info").text.strip,
        "new_free_title"=>items[3].search(".title-info").text.strip,
        "new_free_publisher"=> items[3].search(".add-info").text.strip,
        "new_paid_title"=>items[4].search(".title-info").text.strip,
        "new_paid_publisher"=> items[4].search(".add-info").text.strip
      })
    else
      result.push({
        "free_title"=>items[0].search(".title-info").text.strip,
        "free_publisher"=> items[0].search(".add-info").text.strip,
        "paid_title"=>items[1].search(".title-info").text.strip,
        "paid_publisher"=> items[1].search(".add-info").text.strip,
        "sales_title"=>items[2].search(".title-info").text.strip,
        "sales_publisher"=> items[2].search(".add-info").text.strip,
        "new_free_title"=>items[3].search(".title-info").text.strip,
        "new_free_publisher"=> items[3].search(".add-info").text.strip
      })
    end

  end
  print_in_csv(result)

ensure
  print "\n"
end

