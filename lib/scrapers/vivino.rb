require 'nokogiri'
require 'open-uri'
require 'amatch'
include Amatch

module Scrapers
  class Vivino
    def run
      Wine.find_in_batches do |group|
        group.each do |wine|
          fetch_wine(wine)
        end
      end
    end

    private

    def fetch_wine(wine)
      urls = []
      # Create Levensthein object and downcase and take off special chars
      leven_wine = Levenshtein.new(I18n.transliterate(wine.name.downcase))
      p query = wine.name.gsub(" ","+")
      url = open(normalize_uri("https://www.vivino.com/search?q=#{query}&start=#{@page}"))
      html_doc = Nokogiri::HTML(url, nil, 'utf-8')
      wine_cards = html_doc.search(".wine-card")

      wine_cards.each_with_index do |wine_card, index|
        begin
          vivino_wine = fetch_wines(wine_card.search(".wine-name > a").attribute('href').value, wine.id)

          if index == 0
            vivino_wine.save!
            puts "Challenger => #{vivino_wine.wine_name}"
          else
            result_last = leven_wine.match(I18n.transliterate(ExternalRating.all.last.wine_name.downcase))
            result_new = leven_wine.match(I18n.transliterate(vivino_wine.wine_name.downcase))
            if result_new < result_last
              ExternalRating.all.last.delete
              vivino_wine.save!
              puts "New winner => #{vivino_wine.wine_name}"
              puts "#{result_new} vs #{result_last}"
            else
              puts "Last win !"
              puts "#{result_last} vs #{result_new}"
            end
          end
        rescue NoMethodError => e
          puts "No cards found #{e}"
        end
      end
      puts "<=======================GAME OVER============================> "
    end

    def normalize_uri(uri)
      return uri if uri.is_a?(URI)

      uri = uri.to_s
      uri, *tail = uri.rpartition("#") if uri["#"]

      URI(URI.encode(uri) << Array(tail).join)
    end

    def fetch_wines(wine_url,wine_id)
      grapes = []
      parings = []
      infos = []
      i = 1
      j = 1
      html_wine = Nokogiri::HTML(open("https://www.vivino.com#{wine_url}"), nil, 'utf-8')
      wine_details = html_wine.search(".wine-page-content")

      begin
        e = ExternalRating.new
        wine_details.search('.wine-name span').each do |info|
          infos << info.text.strip
        end
        e.wine_id = wine_id
        e.winery = infos[0]
        e.wine_name = (infos[0] + " " + infos[1] + " " + infos[2]).strip
        e.vintage = infos[2]
        #e.color
        #e.photo = wine_details.search('.wine-page-image-holder img[itemprop=image]').attribute('src')
        e.price = wine_details.search('span[itemprop=price]').text.to_f
        e.winery = wine_details.search('a[data-item-type=winery]').text
        e.appellation = wine_details.search('a[data-item-type=wine-region]').text
        e.region = wine_details.search('a[data-item-type=wine-style]').text
        e.country = wine_details.search('a[data-item-type=Country]').text
        e.avg_rating = wine_details.search('div[itemprop=ratingValue]').text.to_f
        e.rating_count = wine_details.search('span[itemprop=ratingCount]').text.to_i
        # wine_details.search('a[data-item-type=grape]').each do |grape|
        #   e["grape_#{i}"] = grape.text.strip
        #   fetch_grape_info(grape.attributes['href'].value)
        #   i += 1
        # end
        wine_details.search('a[data-item-type=food-pairing]').each do |pairing|
          pairing.text.strip
          e["pairing_#{j}"] = pairing.text.strip
          j += 1
        end
        unless e.avg_rating == 0
          #e.save
          return e
        end

      rescue NoMethodError => e
        puts "No wines wine found #{e}"
      end
    end

    def fetch_grape_info(grape_url)
      infos = []
      cpt = 1
      html_grape = Nokogiri::HTML(open("https://www.vivino.com#{grape_url}"), nil, 'utf-8')
      grape_details = html_grape.search(".wrap")
      begin
        g = Grape.new
        g.name = grape_details.search('.grape-name').text.strip
        grape_details.search('.group span').each do |info|
          infos << info.text
        end
        g.acidity = infos[1]
        g.body = infos[4]
        grape_details.search('.section-bordered.section-md ul li').each do |food|
          g["pairing_#{cpt}"] = food.text.strip
          cpt += 1
        end
        unless Grape.where(name: "#{g.name}").count > 0
          p "grape => #{g.name}"
          g.save!
        end
      rescue NoMethodError => e
        puts "No grapes found #{e}"
      end
    end
  end
end
