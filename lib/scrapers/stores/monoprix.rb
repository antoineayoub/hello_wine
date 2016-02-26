require 'nokogiri'
require 'open-uri'
require 'json'
require 'mechanize'

module Scrapers
  module Stores
    class Monoprix

      def run
        puts "Monoprix Stores is starting"
        brand = Brand.find_by_name("Monoprix")
        brand.stores.destroy_all
        # agent = Mechanize.new
        # page = agent.get("https://www.monoprix.fr/trouver-nos-magasins")

        # form = page.form(:id => 'storeSearchForm')

        # form.checkbox_with(:name => 'monoprix').check
        # form.checkbox_with(:name => 'monopdaily').check
        # form.checkbox_with(:name => 'monop').check

       #Preparing for scraping
        url = open("https://www.monoprix.fr/trouver-nos-magasins")

        html_doc = Nokogiri::HTML(url, nil, 'utf-8')
        #getting all store elements
        stores = html_doc.search("#results>li")
        #stores = page.css('#results>li:not(.storeHidden)')

        stores.each do |store|
          # building store url
          store_partial_url = store.attr("onclick").gsub("window.location.href='", "").gsub("';", "")

          # building store address
          store_street = store.search(".adress-1").text()
          store_city = store.search(".adress-2").text()
          store_address = "#{store_street} #{store_city}"
          # opening & saving store page
          store_url = open("https://www.monoprix.fr#{store_partial_url}")
          html_store_doc = Nokogiri::HTML(store_url, nil, 'utf-8')

          # getting opening / closing hours
          hours_table = html_store_doc.search(".horaires-store tbody tr")
          store_name = html_store_doc.search('.header-locator').text().gsub(/\t*\n*\r*/,'')
          new_store = Store.create(
              brand_id: brand.id,
              name: store_name,
              address: store_address )
          puts "Schedule store #{new_store.id}"
          hours_table.each do |hour|
            # retrieving days of week
            full_day = hour.search('th').text().gsub(/\t*\n*\r*/,'').gsub(" ","")
            days = %w(Lundi Mardi Mercredi Jeudi Vendredi Samedi Dimanche)
            day_nb = 0
            days.each_with_index { |day, index| day_nb = index + 1 if day == full_day }

            # retrieving hours opening / closing
            hour = hour.search('td').text().gsub(/\t*\n*\r*/,'').gsub(" ","").gsub("h",":")
            am = hour.split("-")[0]
            pm = hour.split("-")[1]

            # building schedule
            store_schedule = StoreSchedule.create(
                store_id: new_store.id,
                day: day_nb,
                start_am: am,
                end_pm: pm )
          end

        end
      end
    end
  end
end
