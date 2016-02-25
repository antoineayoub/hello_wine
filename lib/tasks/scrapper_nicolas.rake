require 'nokogiri'
require 'open-uri'
require 'csv'
require 'json'
require 'net/http'


def store_scraping

  Store.where("brand_id = 1").destroy_all

  day = 0
  am = []
  pm =[]
  start_am = end_am = start_pm = end_pm = []
  store_id = 0

  (0..NB_PAGE_STORE).each do |page|
    store_list = open("http://www.nicolas.com/fr/store-finder?q=75&page=#{page}")
    doc = Nokogiri::HTML(store_list, nil, 'utf-8')
    doc.css('.storeMap').each do |element|
      (0..NB_STORE_BY_PAGE).each do |i|

        time_position = 0
        store = JSON.parse(element.attribute("data-stores"))
        new_store = Store.create(brand_id: Brand.where(name: BRAND).first.id,name: store["store#{i}"]["displayName"], address: [store["store#{i}"]["address"] ,store["store#{i}"]["postcode"], store["store#{i}"]["town"]].join(' '))
        store_details = open("http://www.nicolas.com/#{store["store#{i}"]["urlDetail"]}")
        doc = Nokogiri::HTML(store_details, nil, 'utf-8')
        doc.css('.weekday_openings').each do |detail|
          # detail.css('.ns-StoreDetails-openingsDayDetail').each do |day|
          #   days << day.text().strip
          # end
          detail.css('.ns-StoreDetails-openingsTimesDetail').each do |hour|
            am = hour.css('.ns-StoreDetails-openingsTimesDetailAM').text().strip.gsub(/\n\t*\s/,'-').split('-')
            pm = hour.css('.ns-StoreDetails-openingsTimesDetailPM').text().strip.gsub(/\n\t*/,'-').split('-')
            if am.count == 1 && pm.count == 1
              start_am = am[0]
              end_am = nil
              start_pm = nil
              end_pm = pm[0]
            elsif am.count == 0 && pm.count == 2
              start_am = nil
              end_am = nil
              start_pm = pm[0]
              end_pm = pm[1]
            elsif am.count == 2 && pm.count == 0
              start_am = am[0]
              end_am = am[1]
              start_pm = nil
              end_pm = nil
            elsif am.count == 2 && pm.count == 2
              start_am = am[0]
              end_am = am[1]
              start_pm = pm[0]
              end_pm = pm[1]
            elsif am.count == 0 && pm.count == 0
              start_am = end_am = start_pm = end_pm = nil
            end
            store_schedule = StoreSchedule.create( store_id: new_store.id, day: day + 1, start_am: start_am ,end_am: end_am ,start_pm: start_pm ,end_pm: end_pm)
            start_am = end_am = start_pm = end_pm = []
            day += 1
            day = 0 if day == 7
          end
        end
        am = []
        pm =[]
        store_id += 1
      end
    end
  end
end

def wine_scraping

  Wine.where("brand_id = 1").destroy_all


  (0..NB_WINE_PAGES).each do |page|
    begin
      wine_list = open("http://www.nicolas.com/fr/Vins/c/01/?q=%3Arelevance&page=#{page}&show=All")
      puts "URL PAGE"
      p "http://www.nicolas.com/fr/Vins/c/01/?q=%3Arelevance&page=#{page}&show=All"
      p page
      url = URI.parse("http://www.google.com/")
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)

      doc = Nokogiri::HTML(wine_list, nil, 'utf-8')
      doc.search('.ns-Product').each do |wines|
        begin
          puts "URL part"
          p url = wines.css('a').attribute('href').value.gsub(/\s/,'%20')
          wine = Wine.new({
                  name: wines.css('a').attribute('title').value.strip,
                  remote_photo_url: wines.css('.ns-Product-img').attribute('src').value,
                  region: wines.css('.ns-Product-district').text().gsub(/\n*\t*/,''),
                  appellation: wines.css('.ns-Product-domain').text().gsub(/\n*\t*/,''),
                  price: (wines.css('.ns-Price-unity').text() + wines.css('.ns-Price-decimal').text()).to_f,
                  brand_id: Brand.where(name: BRAND).first.id
                })

          res = Net::HTTP.get_response(URI("http://www.nicolas.com#{url}"))

          p res['location']
          wine_detail = open("http://www.nicolas.com#{url}")

          # doc = Nokogiri::HTML(wine_detail, nil, 'utf-8')
          # doc.search('.ns-ProductDetails-infos').each do |w|
          #   # Couleur et T°
          #   wine[:color] = w.css('.ns-ProductDetails-cara > .ns-Product-cara').last.text().strip.gsub(/\n*\s/,'').split('|')[0]
          #   wine[:alcohol_percent] = w.css('.ns-ProductDetails-cara > .ns-Product-cara').last.text().strip.gsub(/\n*\s/,'').split('|')[1].to_f

          #   # Cepages
          #   i = 1
          #   w.css('.ns-ProductGrappe-value--grape').text.strip.split(/\n/).each do |t|
          #     wine["grape_#{i}"] = t.strip
          #     i += 1
          #   end
          #   # Accord mets / vins
          #   j = 1
          #   w.css('.ns-AgreementList-description').each do |t|
          #     wine["pairing_#{j}"] = t.text.strip
          #     j += 1
          #   end
          # end

          # doc.search('.ns-Oenologist').each do |w|
          #   # Description
          #   wine[:description] = w.css('.ns-Oenologist-tastingContent').first.search('p').last.text
          # end
          # wine.save!

        rescue NoMethodError => e
          puts "No wine found #{e}"
          puts wines.css('a').attribute('href').value.gsub(/\s/,'%20')
        end
      end
    rescue NoMethodError => e
      puts "No page found #{e}"
    end
  end
end

desc "Scraper Nicolas"
task :scraper_nicolas => [:environment] do

  NB_PAGE_STORE = 33
  NB_STORE_BY_PAGE = 9
  NB_WINE_PAGES = 3
  BRAND = 'Nicolas'

  puts "What would you like to scrap ?"
  puts "1- All"
  puts "2- Stores"
  puts "3- Wines"
  puts "4- Exit"
  result = STDIN.gets.chomp.to_i

  if result == 1
    store_scraping
    wine_scraping
  elsif result == 2
    store_scraping
  elsif result == 3
    wine_scraping
  else
    exit
  end

# require 'aws-sdk'
#  s3 = Aws::S3::Resource.new

#   # reference an existing bucket by name
#   bucket = s3.bucket(ENV["AWS_S3_BUCKET_NAME"])


#   # delete all of the objects in a bucket (optionally with a common prefix as shown)
#   bucket.objects(prefix: 'uploads/Wine/').batch_delete!
end

