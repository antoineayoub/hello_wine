require 'open-uri'
require 'net/http'
require 'nokogiri'

module Scrapers
  module Wines
    class Monoprix
      def run
        # puts "Deleting Wines Monoprix"
        # # brand = Brand.find_by_name("Monoprix")
        # # brand.wines.destroy_all
        # puts "End deleting"
        p get_wine("white", "/vin-blanc-sec-0000532", get_nb_page("/vin-blanc-sec-0000532"), brand)
        p get_wine("red", "/vin-rouge-0000536", get_nb_page("/vin-rouge-0000536"), brand)
        p get_wine("pink", "/vin-rose-0000535", get_nb_page("/vin-rose-0000535"), brand)
        p get_wine("red", "/rouge-0000176", get_nb_page("/rouge-0000176"), brand)
        p get_wine("white", "/blanc-10039", get_nb_page("/blanc-10039"), brand)
        p get_wine("pink", "/rose-0000173", get_nb_page("/rose-0000173"), brand)
      end

      private
      def get_nb_page(url)
        begin
          html_file = open("https://www.monoprix.fr#{url}")
          html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')
          nb_page = html_doc.search('.pagination > ul > li').children[-2].text.to_i
        rescue NoMethodError => e
          return 1
        end
      end

      def get_wine(color, url, nb_pages, brand)
        for i in (1..nb_pages)
          html_file = open("https://www.monoprix.fr#{url}/page-#{i}")
          html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')

          wines = html_doc.search('.item_produits_courses > ul > li')
          wines.each do |wine|
            begin
              appellation   = wine.search('div.desc-info > ul > li.desc > span').text.gsub(/\s*\d*[., ]\d*\s*%\s*(vol.)*/,"").gsub(/\d*\s*(cl)\s*/,"").gsub(/,/," ").gsub(/\s+/," ")
              price         = wine.search('.desc-price > span.price').text.gsub(/\t*\n*/,'').gsub(" ","").gsub(",",".").to_f
              preview_url   = wine.search('a').attribute('href').value
              url_product   = "https://www.monoprix.fr#{preview_url}"
              wine_details  = Nokogiri::HTML(open(url_product), nil, 'utf-8')

              name              = wine_details.css('.brand').first.children.first.text.split(',').first.gsub(/\t*\n*/,'')
              description       = wine_details.search('#desc').text.gsub(/\n+/,'').gsub(/\t+/,' ').gsub(/\s+/,' ')
              alcohol_percent   = wine_details.search('.description_produits h5').text.match(/\d{2}.\d%/)[0].to_f
              img               = wine_details.search('.contentProduct img').first['src']
              cepage            = wine_details.search("#ingredients").text.strip
              breadcrumb        = wine_details.css("#mpx-breadcrumb .breadcrumb li a")
              red_wine_details  = breadcrumb.search("[href='#{url}']").first

              if red_wine_details
                index   = breadcrumb.index(red_wine_details)
                region  = breadcrumb[index + 1].text.strip
                region = "" if region == "none"
              else
                region = "none"
              end
              color = color
            rescue NoMethodError => e
               e
            end

            unless name.nil? || name == "Monoprix" || name.include?("Monoprix -")
              if name.include?("Monoprix Gourmet - ")
                name.slice! "Monoprix Gourmet - "
              elsif name == "Monoprix Gourmet" || name == "PREMIER PRIX" || name == "MARQUE NATIONALE"
                name = appellation
              elsif name.include?("- Monoprix Bio")
                name.slice! "- Monoprix Bio"
              elsif name.include?("SELECT MPX BIO")
                name.slice! "SELECT MPX BIO"
              end
              name = name.gsub(/\d*[., ]*\d*\s*%\s*(vol.)*(VOL.)*(VOL)*/,"").gsub(/\d*\s*(cl)\s*/,"").gsub(/,/," ").gsub(/\s+/," ").gsub(/\s-\s/," ").strip
              name = name.downcase + " " + appellation.downcase
              name = name.split(" ")
              name.delete("-")
              name.uniq! unless name.uniq!.nil?
              p name = I18n.transliterate(name.join(" ")).upcase
              wine = {
                      brand_id: brand.id,
                      color: color,
                      name: name,
                      vintage: name[/\d{4}/],
                      description: description,
                      appellation: appellation,
                      region: region,
                      alcohol_percent: alcohol_percent,
                      remote_photo_url: img,
                      price: price
                    }
              find_wine = Wine.find_by_name(wine[:name])

              if find_wine
                find_wine.update(wine)
                puts "updated"
              else
                Wine.create!(wine)
                puts "created"
              end
            end
          end
        end
      end
    end
  end
end
