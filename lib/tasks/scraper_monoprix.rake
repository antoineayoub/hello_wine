require 'nokogiri'
require 'open-uri'
require 'csv'

def get_wine(color, url, nb_pages)

  for i in (1..nb_pages)
    html_file = open("https://www.monoprix.fr#{url}/page-#{i}")
    html_doc  = Nokogiri::HTML(html_file, nil, 'utf-8')

    wines = html_doc.search('.item_produits_courses > ul > li')
    wines.each do |wine|
      begin
        appellation   = wine.search('div.desc-info > ul > li.desc > span').text
        price         = wine.search('.desc-price > span.price').text.gsub(/\t*\n*/,'').gsub(" ","").gsub(",",".").to_f
        preview_url   = wine.search('a').attribute('href').value
        url_product   = "https://www.monoprix.fr#{preview_url}"
        wine_details  = Nokogiri::HTML(open(url_product), nil, 'utf-8')

        name              = wine_details.css('.brand').first.children.first.text.split(',').first.gsub(/\t*\n*/,'')
        description       = wine_details.search('#desc').text.strip
        alcohol_percent   = wine_details.search('.description_produits h5').text.match(/\d{2}.\d%/)[0].to_f
        img               = wine_details.search('.contentProduct img').first['src']
        cepage            = wine_details.search("#ingredients").text.strip
        breadcrumb        =  wine_details.css("#mpx-breadcrumb .breadcrumb li a")
        red_wine_details  = breadcrumb.search("[href='#{url}']").first
        if red_wine_details
          index   = breadcrumb.index(red_wine_details)
          region  = breadcrumb[index + 1].text.strip
        else
          region = "none"
        end
        color = color
      rescue NoMethodError => e
         e
      end

      name        = "" if name.nil?
      appellation = "" if appellation.nil?
      price       = "" if price.nil?
      description = "" if description.nil?
      alcohol_percent = "" if alcohol_percent.nil?
      img             = "" if img.nil?
      cepage  = "" if cepage.nil?
      region  = "" if region.nil?
      color   = "" if color.nil?

      name.slice! "Monoprix Gourmet - " if name.include?("Monoprix Gourmet - ")

      unless name == ""
        Wine.create!({
          brand_id: 2,
          color: color,
          name: name,
          description: description,
          appellation: appellation,
          region: region,
          alcohol_percent: alcohol_percent,
          remote_photo_url: img,
          price: price
        })
      end
    end
  end
end

desc "Scraper Monoprix"
task :scraper_monoprix => [:environment] do
  Wine.where("brand_id = 2").destroy_all

  get_wine("Blanc", "/vin-blanc-sec-0000532",2)
  get_wine("Rouge", "/vin-rouge-0000536",4)
  get_wine("Rose", "/vin-rose-0000535",2)
end

