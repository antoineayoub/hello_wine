require 'nokogiri'
require 'open-uri'
require 'csv'
require 'json'

def store_scrapping

  Store.where("brand_id = 1").destroy_all

  filepath_stores = 'db/stores.csv'
  filepath_schedules = 'db/schedules.csv'
  days = %w(Lundi Mardi Mercredi Jeudi Vendredi Samedi Dimanche)
  day = 0
  am = []
  pm =[]
  start_am = end_am = start_pm = end_pm = []
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
            strores_csv << [Brand.where(name: BRAND).first.id,store["store#{i}"]["displayName"], store["store#{i}"]["address"] ,store["store#{i}"]["postcode"], store["store#{i}"]["town"] ]
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
                schedules_csv << [store_id, days[day], start_am ,end_am ,start_pm ,end_pm]
                store_schedule = StoreSchedule.create( store_id: new_store.id, day: days[day], start_am: start_am ,end_am: end_am ,start_pm: start_pm ,end_pm: end_pm)
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
  end
end

def wine_scraping

  Wine.where("brand_id = 1").destroy_all

  filepath_wines = 'db/wines.csv'
  CSV.open(filepath_wines, 'wb', CSV_OPTIONS) do |wines_csv|
    (0..NB_WINE_PAGES).each do |page|
      wine_list = open("http://www.nicolas.com/fr/Vins/c/01/?q=%3Arelevance&page=#{page}&show=All")
      doc = Nokogiri::HTML(wine_list, nil, 'utf-8')
      doc.search('.ns-Product').each do |wines|
        begin
          url = wines.css('a').attribute('href').value.gsub('  ','%20%20')
          wine = Wine.new({
                  name: wines.css('a').attribute('title').value,
                  remote_photo_url: wines.css('.ns-Product-img').attribute('src').value,
                  region: wines.css('.ns-Product-district').text().gsub(/\n*\t*/,''),
                  appellation: wines.css('.ns-Product-domain').text().gsub(/\n*\t*/,''),
                  price: (wines.css('.ns-Price-unity').text() + wines.css('.ns-Price-decimal').text()).to_f,
                  #size: wines.css('.ns-Product-bottle').text().gsub(/\n*\t*/,''),
                  brand_id: Brand.where(name: BRAND).first.id
                })
          wine_detail = open("http://www.nicolas.com#{url}")
          doc = Nokogiri::HTML(wine_detail, nil, 'utf-8')
          doc.search('.ns-ProductDetails-infos').each do |w|
            # Couleur et T°
            wine[:color] = w.css('.ns-ProductDetails-cara > .ns-Product-cara').last.text().strip.gsub(/\n*\s/,'').split('|')[0]
            wine[:alcohol_percent] = w.css('.ns-ProductDetails-cara > .ns-Product-cara').last.text().strip.gsub(/\n*\s/,'').split('|')[1]
            # Cepages
            i = 1
            w.css('.ns-ProductGrappe-value--grape').text.strip.split(/\n/).each do |t|
              wine["cepage_#{i}"] = t.strip
              i += 1
            end
            # Accord mets / vins
            j = 1
            w.css('.ns-AgreementList-description').each do |t|
              wine["pairing_#{j}"] = t.text.strip
              j += 1
            end
          end

          doc.search('.ns-Oenologist').each do |w|
            # Corps / Fraicheur / Evolution / Tannins
            # ["corp", "fraicheur", "evolution", "tannins"]
            # val = []
            # # w.css('.ns-SliderRange-container').each do |t|
            # #   val << (t.css('.ns-SliderRange-bullet').attribute('style').value.gsub(/\D/,'').to_i * 8) / 385
            # # end

            # Description
            wine[:description] = w.css('.ns-Oenologist-tastingContent').first.search('p').last.text
          end
          wines_csv << Array(wine)

          wine.save!
          # doc.search('.ns-Chart-legend > li').each do |w|
          #   w.search('.ns-Chart-legendLabel').text
          #   w.search('span').last.text
          # end
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
  BRAND = 'Nicolas'

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
