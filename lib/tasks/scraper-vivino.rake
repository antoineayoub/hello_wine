require 'nokogiri'
require 'open-uri'

desc "Scrappe Nicolas"
task :scraper_vivino => [:environment] do

  Vivino.new(["boutisse", "la tour", "lafitte"])

  class Vivino

    def initialize(wines_to_search)
      @wines_to_search = wines_to_search
      @csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
      @filepath_stores = 'db/scraper-vivino.csv'
      @wines = []
      fetch_data
    end

    def fetch_data
      @wines_to_search.each do |wine_to_search|
        query = wine_to_search.gsub(" ","+")
        @url = open("https://www.vivino.com/search?q=#{query}&start=#{@page}")
        @html_doc = Nokogiri::HTML(@url, nil, 'utf-8')
        wine_cards = @html_doc.search(".wine-card")

        wine_cards.each do |wine_card|
          unless wine_card.search("[itemprop='ratingValue']").text == ""
            wine_title = wine_card.search(".winery.header-small").text.downcase.strip
            wine_name = wine_card.search(".wine-name").text.downcase.strip
            avg_rating = wine_card.search("[itemprop='ratingValue']").text.gsub(",",".").to_f
          end
          # rescue
          begin
          nb_ratings = wine_card.search("[itemprop='reviewCount']").attr("content").text.to_i
          rescue NoMethodError => e
            "no reviews on this wine: #{e}"
          end

          ExternalRating.create({
            wine_title: wine_title,
            wine_name: wine_name,
            avg_rating: avg_rating,
            nb_ratings: nb_ratings
          })

        end
        # begin
        # fetch_data unless @html_doc.search("button.btn-page")[1].attr("disabled") == "disabled"
        # rescue NoMethodError => e
        #   "no more pages on this wine: #{e}"
        # end
      end
    end
  end

end
