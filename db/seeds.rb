# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'open-uri'

brand = 'monoprix'
# preparing for scraping
url = open("https://www.monoprix.fr/trouver-nos-magasins")
html_doc = Nokogiri::HTML(url, nil, 'utf-8')
# getting all store elements
stores = html_doc.search("#results>li")

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
  p new_store = Store.create(
      brand_id: 2,
      name: store_name,
      address: store_address )

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
    p store_schedule = StoreSchedule.create(
        store_id: new_store.id,
        day: day_nb,
        start_am: am,
        end_pm: pm )
  end

end
