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
      @wine_to_search = wine_to_search.name
      @wine_id = wine_to_search.id
      fetch_data
    end

    def fetch_data
      query = @wine_to_search.gsub(" ","+")
      @url = open(normalize_uri("https://www.vivino.com/search?q=#{query}&start=#{@page}"))
      @html_doc = Nokogiri::HTML(@url, nil, 'utf-8')
      wine_cards = @html_doc.search(".wine-card")

      wine_cards.each do |wine_card|
        unless wine_card.search("[itemprop='ratingValue']").text == ""
          wine_name = wine_card.search(".winery.header-small").text.downcase.strip
          wine_info = wine_card.search(".wine-name").text.downcase.strip
          avg_rating = wine_card.search("[itemprop='ratingValue']").text.gsub(",",".").to_f
          nb_ratings = wine_card.search("[itemprop='reviewCount']").attr("content").text.to_i
          ExternalRating.create!({
            wine_info: wine_info,
            wine_name: wine_name,
            avg_rating: avg_rating,
            nb_ratings: nb_ratings,
            wine_id: @wine_id
          })
        end
      end
    end
  end
  cpt = 0
  Wine.all.each do |wine|
    Vivino.new(wine)
  end

end
