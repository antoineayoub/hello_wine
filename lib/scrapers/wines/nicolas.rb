require 'open-uri'
require 'net/http'
require 'nokogiri'

module Scrapers
  module Wines
    NB_WINE_PAGES = 3

    class Nicolas
      def run
        # puts "Deleting Wines Nicolas"
        brand = Brand.find_by_name("Nicolas")
        # brand.wines.destroy_all
        # puts "End deleting"
        (0..NB_WINE_PAGES).each do |page|
          puts "Page n°#{page}"
          begin
            wine_list = open("http://www.nicolas.com/fr/Vins/c/01/?q=%3Arelevance&page=#{page}&show=All")
            url = URI.parse("http://www.google.com/")
            req = Net::HTTP.new(url.host, url.port)
            res = req.request_head(url.path)

            doc = Nokogiri::HTML(wine_list, nil, 'utf-8')
            doc.search('.ns-Product').each do |wines|
              begin
                url = wines.css('a').attribute('href').value.gsub(/\s/,'%20')
                p name = wines.css('a').attribute('title').value
                p name = I18n.transliterate(name.gsub(/\s-\s/," ").gsub(/,/,"").strip).upcase
                p appelation = wines.css('.ns-Product-domain').text().gsub(/\n*\t*/,'')
                wine = {
                        name: name,
                        vintage: name[/\d{4}/],
                        remote_photo_url: wines.css('.ns-Product-img').attribute('src').value,
                        region: wines.css('.ns-Product-district').text().gsub(/\n*\t*/,''),
                        appellation: appelation,
                        price: (wines.css('.ns-Price-unity').text() + wines.css('.ns-Price-decimal').text()).to_f,
                        brand_id: brand.id
                      }

                wine_detail = open("http://www.nicolas.com#{url}")

                doc = Nokogiri::HTML(wine_detail, nil, 'utf-8')
                doc.search('.ns-ProductDetails-infos').each do |w|
                  # Couleur et T°
                  wine[:color] = w.css('.ns-ProductDetails-cara > .ns-Product-cara').last.text().strip.gsub(/\n*\s/,'').split('|')[0]
                  if wine[:color] == "Rouge"
                    wine[:color] = "red"
                  elsif wine[:color] == "Blanc"
                    wine[:color] = "white"
                  elsif wine[:color] == "Rosé"
                    wine[:color] = "pink"
                  end


                  wine[:alcohol_percent] = w.css('.ns-ProductDetails-cara > .ns-Product-cara').last.text().strip.gsub(/\n*\s/,'').split('|')[1].to_f

                  # Cepages
                  i = 1
                  w.css('.ns-ProductGrappe-value--grape').text.strip.split(/\n/).each do |t|
                    wine["grape_#{i}"] = t.strip
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
                  # Description
                  wine[:description] = w.css('.ns-Oenologist-tastingContent').first.search('p').last.text
                end
                find_wine = Wine.find_by_name(wine[:name])

                if find_wine
                  find_wine.update(wine)
                  puts "updated"
                else
                  Wine.create!(wine)
                  puts "created"
                end

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
    end
  end
end
