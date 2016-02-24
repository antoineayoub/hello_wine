require 'nokogiri'
require 'open-uri'
require 'cloudinary'
require 'csv'




def get_wine(color, url, nb_pages)
  wine_hash = []

  for i in (1..nb_pages)
  html_file = open("#{url}/page-#{i}")
  html_doc = Nokogiri::HTML(html_file, nil, 'utf-8')

    wines = html_doc.search('.item_produits_courses > ul > li')
    wines.each do |wine|
      begin
        appellation = wine.search('div.desc-info > ul > li.desc > span').text
        price   = wine.search('.desc-price > span.price').text.gsub(/\t*\n*/,'').gsub(" ","").gsub(",",".").to_f
        url     = wine.search('a').attribute('href').value
        url_product   = "https://www.monoprix.fr#{url}"
        wine_details  = Nokogiri::HTML(open(url_product), nil, 'utf-8')

        name      = wine_details.css('.brand').first.children.first.text.split(',').first.gsub(/\t*\n*/,'')
        description = wine_details.search('#desc').text.strip
        alcohol_percent = wine_details.search('.description_produits h5').text.match(/\d{2}.\d%/)[0]
        img         = wine_details.search('.contentProduct img').first['src']
        cepage      = wine_details.search("#ingredients").text.strip
        breadcrumb        =  wine_details.css("#mpx-breadcrumb .breadcrumb li a")
        red_wine_details  = breadcrumb.search("[title='Vin rouge']").first
        if red_wine_details
          index   = breadcrumb.index(red_wine_details)
          region  = breadcrumb[index + 1].text.strip
        else
          region = "Région non dispo"
        end
        color = color
      rescue NoMethodError => e
         e
      end

      name        = "" if name.nil?
      appellation = "" if name.nil?
      price       = "" if price.nil?
      description = "" if description.nil?
      alcohol_percent = "" if alcohol_percent.nil?
      img             = "" if img.nil?
      cepage  = "" if cepage.nil?
      region  = "" if region.nil?
      color   = "" if color.nil?

      unless name == ""
        p name
        p price
      end
      # unless name.nil? || appellation.nil? || description.nil? || region.nil?
      # p  name.squish
      # p  appellation.squish
      # p  price
      # p  description.squish
      # p  alcohol_percent
      # p  img
      # p  cepage.squish
      # p  region.squish
      # p  color.squish
      # end



      wine_hash << {
        brand: "monoprix",
        name: name.squish,
        appellation: appellation.squish,
        price: price,
        description: description.squish,
        alcohol_percent: alcohol_percent,
        img: img.squish,
        cepage: cepage.squish,
        region: region.squish,
        color: color.squish
      }
    end
  end
end



get_wine("vin blanc", "https://www.monoprix.fr/vin-blanc-sec-0000532",2)
get_wine("vin rouge", "https://www.monoprix.fr/vin-rouge-0000536",4)
get_wine("vin rose", "https://www.monoprix.fr/vin-rose-0000535",2)


# csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
# filepath    = 'db/monoprix.csv'
# CSV.open(filepath, 'wb', csv_options) do |csv|
#   csv << ['Name', 'Appellation', 'Color', 'Price', 'Url image', 'alcohol_percent', 'region', 'description' , 'cepage']
#   wine_hash.each do |wine|
#     csv << [
#       wine[:name],
#       wine[:appellation],
#       wine[:color],
#       wine[:price],
#       wine[:img],
#       wine[:alcohol_percent],
#       wine[:region],
#       wine[:description],
#       wine[:cepage]
#     ]
#   end
# end


# CSV.foreach(filepath, csv_options) do |row|
#   puts row
# end


