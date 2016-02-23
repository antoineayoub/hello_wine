require 'nokogiri'
require 'open-uri'
require 'csv'
require 'json'

def store_scrapping

  Store.where(name: 'nicolas').destroy_all

  filepath_stores = 'db/stores.csv'
  filepath_schedules = 'db/schedules.csv'
  days = []
  am = []
  pm =[]
  store_id = 0
  CSV.open(filepath_stores, 'wb', CSV_OPTIONS) do |strores_csv|
    CSV.open(filepath_schedules, 'wb', CSV_OPTIONS) do |schedules_csv|
      (0..NB_PAGE_STORE).each do |page|
        store_list = open("http://www.nicolas.com/fr/store-finder?q=75&page=#{page}")
        doc = Nokogiri::HTML(store_list, nil, 'utf-8')
        doc.css('.storeMap').each do |element|
          (0..NB_STORE_BY_PAGE).each do |i|

            time_position = 0
            store = JSON.parse(element.attribute("data-stores"))
            strores_csv << [store_id,'nicolas', store["store#{i}"]["displayName"], store["store#{i}"]["address"] ,store["store#{i}"]["postcode"], store["store#{i}"]["town"] ]
            new_store = Store.new(brand: 'nicolas',name: store["store#{i}"]["displayName"], address: [store["store#{i}"]["address"] ,store["store#{i}"]["postcode"], store["store#{i}"]["town"]].join(' '))
            new_store.save
            store_details = open("http://www.nicolas.com/#{store["store#{i}"]["urlDetail"]}")
            doc = Nokogiri::HTML(store_details, nil, 'utf-8')
            doc.css('.weekday_openings').each do |detail|
              detail.css('.ns-StoreDetails-openingsDayDetail').each do |day|
                days << day.text().strip
              end
              detail.css('.ns-StoreDetails-openingsTimesDetail').each do |hour|
                am << hour.css('.ns-StoreDetails-openingsTimesDetailAM').text().strip.gsub(/\n\t*\s/,'-')
                pm << hour.css('.ns-StoreDetails-openingsTimesDetailPM').text().strip.gsub(/\n\t*/,'-')
              end
            end
            days.each do |day|
              schedules_csv << [store_id, day, am[time_position], pm[time_position] ]
              store_schedule = StoreSchedule.new( store_id: new_store.id, day: day, start_at:am[time_position],close_at:pm[time_position] )
              store_schedule.save
              time_position += 1
            end
            days = []
            am = []
            pm =[]
            store_id += 1
          end
        end
      end
    end
  end
end

def wine_scraping
  filepath_wines = 'db/wines.csv'
  CSV.open(filepath_wines, 'wb', CSV_OPTIONS) do |wines_csv|
    (0..NB_WINE_PAGES).each do |page|
      wine_list = open("http://www.nicolas.com/fr/Vins/c/01/?q=%3Arelevance&page=#{page}&show=All")
      doc = Nokogiri::HTML(wine_list, nil, 'utf-8')
      doc.search('.ns-Product').each do |wines|
        begin
          wine = {
                  url: wines.css('a').attribute('href').value.gsub('  ','%20%20'),
                  name: wines.css('a').attribute('title').value,
                  img: wines.css('.ns-Product-img').attribute('src').value,
                  district: wines.css('.ns-Product-district').text().gsub(/\n*\t*/,''),
                  domain: wines.css('.ns-Product-domain').text().gsub(/\n*\t*/,''),
                  price: (wines.css('.ns-Price-unity').text() + wines.css('.ns-Price-decimal').text()).to_f,
                  size: wines.css('.ns-Product-bottle').text().gsub(/\n*\t*/,'')
                }
          wine_detail = open("http://www.nicolas.com#{wine[:url]}")
          doc = Nokogiri::HTML(wine_detail, nil, 'utf-8')
          doc.search('.ns-ProductDetails-infos').each do |w|
            # Couleur et T°
            w.css('.ns-ProductDetails-cara > .ns-Product-cara').last.text().strip.gsub(/\n*\s/,'').split('|')

            # Cepages
            i = 0
            w.css('.ns-ProductGrappe-value--grape').text.strip.split(/\n/).each do |t|
              wine["cepage_#{i}"] = t.strip
              i += 1
            end
            # Accord mets / vins
            j = 0
            w.css('.ns-AgreementList-description').each do |t|
              wine["accord_#{j}"] = t.text.strip
              j += 1
            end
          end

          doc.search('.ns-Oenologist').each do |w|
            # Corps / Fraicheur / Evolution / Tannins
            # ["corp", "fraicheur", "evolution", "tannins"]
            val = []
            w.css('.ns-SliderRange-container').each do |t|
              val << (t.css('.ns-SliderRange-bullet').attribute('style').value.gsub(/\D/,'').to_i * 8) / 385
            end

            # Description
            wine[:description] = w.css('.ns-Oenologist-tastingContent').first.search('p').last.text
          end

          doc.search('.ns-Chart-legend > li').each do |w|
            w.search('.ns-Chart-legendLabel').text
            w.search('span').last.text
          end
        rescue NoMethodError => e
          puts "No wine found #{e}"
        end
      end
    end
  end
end

desc "Scrappe Nicolas"
task :scrappe_nicolas => [:environment] do

  CSV_OPTIONS = { col_sep: ',', force_quotes: true, quote_char: '"' }
  NB_PAGE_STORE = 33
  NB_STORE_BY_PAGE = 9
  NB_WINE_PAGES = 3

  puts "What would you like to scrap ?"
  puts "1- All"
  puts "2- Stores"
  puts "3- Wines"
  puts "4- Exit"
  result = STDIN.gets.chomp.to_i

  if result == 1
    store_scrapping
    wine_scraping
  elsif result == 2
    store_scrapping
  elsif result == 3
    wine_scraping
  else
    exit
  end


end
