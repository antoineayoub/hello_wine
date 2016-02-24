require 'nokogiri'
require 'open-uri'

desc "Scrappe Vivino"
task :scraper_vivino => [:environment] do
  class Vivino

    def normalize_uri(uri)
      return uri if uri.is_a? URI

      uri = uri.to_s
      uri, *tail = uri.rpartition "#" if uri["#"]

      URI(URI.encode(uri) << Array(tail).join)
    end

    def initialize(wine_to_search)
      @urls = []
      @wine_to_search = wine_to_search.name
      @wine_id = wine_to_search.id
      fetch_urls
    end

    def fetch_urls
      query = @wine_to_search.gsub(" ","+")
      url = open(normalize_uri("https://www.vivino.com/search?q=#{query}&start=#{@page}"))
      html_doc = Nokogiri::HTML(url, nil, 'utf-8')
      wine_cards = html_doc.search(".wine-card")

      wine_cards.each do |wine_card|
        begin
        #unless wine_card.search("[itemprop='ratingValue']").text == ""
        #end
          @urls << wine_card.search(".wine-name > a").attribute('href').value
        rescue NoMethodError => e
          puts "No cards found #{e}"
        end
      end

      @urls.each do |url|
        fetch_wines(url)
      end
    end

    def fetch_wines(wine_url)
      grapes = []
      foods = []
      infos = []
      html_wine = Nokogiri::HTML(open("https://www.vivino.com#{wine_url}"), nil, 'utf-8')
      wine_details = html_wine.search(".wine-page-content")
      wine_details.search('.wine-name span').each do |info|
        p infos << info.text.strip
      end
      src_img = wine_details.search('.wine-page-image-holder img[itemprop=image]').attribute('src')
      price = wine_details.search('span[itemprop=price]').text.to_f
      winery = wine_details.search('a[data-item-type=winery]').text
      appelation = wine_details.search('a[data-item-type=wine-region]').text
      region = wine_details.search('a[data-item-type=wine-style]').text
      country = wine_details.search('a[data-item-type=Country]').text
      avg_rating = wine_details.search('div[itemprop=ratingValue]').text.to_f
      rating_count = wine_details.search('span[itemprop=ratingCount]').text.to_i
      wine_details.search('a[data-item-type=grape]').each do |grape|
        grapes << grape.text.strip
      end
      wine_details.search('a[data-item-type=food-pairing]').each do |food|
        foods << food.text.strip
      end
      # ExternalRating.create!({
      #   wine_info: wine_info,
      #   wine_name: wine_name,
      #   avg_rating: avg_rating,
      #   nb_ratings: nb_ratings,
      #   wine_id: @wine_id
      # })
    end
  end

  Wine.all.each do |wine|
    Vivino.new(wine)
  end

end
