require 'nokogiri'
require 'open-uri'
require 'cloudinary'
require 'csv'
require 'json'


csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
filepath_stores = 'db/stores.csv'
filepath_schedules = 'db/schedules.csv'
filepath_wines = 'db/wines.csv'
days = []
am = []
pm =[]
store_id = 0

CSV.open(filepath_stores, 'wb', csv_options) do |strores_csv|
  CSV.open(filepath_schedules, 'wb', csv_options) do |schedules_csv|
    (0..33).each do |page|
      store_list = open("http://www.nicolas.com/fr/store-finder?q=75&page=#{page}")
      doc = Nokogiri::HTML(store_list, nil, 'utf-8')
      doc.css('.storeMap').each do |element|
        (0..9).each do |i|
          time_position = 0
          store = JSON.parse(element.attribute("data-stores"))
          strores_csv << [store_id,'Nicolas', store["store#{i}"]["displayName"], store["store#{i}"]["address"] ,store["store#{i}"]["postcode"], store["store#{i}"]["town"] ]
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

CSV.open(filepath_stores, 'wb', csv_options) do |filepath_wines|
  (0..1).each do |page|
    wine_list = open("http://www.nicolas.com/fr/Vins/c/01/?q=%3Arelevance&page=#{page}&show=All")
    doc = Nokogiri::HTML(wine_list, nil, 'utf-8')
    doc.search('.ns-Product').each do |wines|
      unless wines.css('a').attribute('title').nil?
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
      end
    end
  end
end
