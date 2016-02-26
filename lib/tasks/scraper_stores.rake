require 'scrapers/stores/monoprix'
require 'scrapers/stores/nicolas'

desc "Scraper Stores"
task :scraper_stores => [:environment] do

  puts "What would you like to scrap ?"
  puts "1- Nicolas"
  puts "2- Monoprix"
  puts "3- All"
  puts "4- Exit"
  result = STDIN.gets.chomp.to_i

  if result == 1
    store_scraper_nicolas
  elsif result == 2
    store_scraper_monoprix
  elsif result == 3
    store_scraper_monoprix
    store_scraper_nicolas
    store_scraper_monoprix
  else
    exit
  end
end

def store_scraper_monoprix
  Scrapers::Stores::MonoprixJob.new.run
end

def store_scraper_nicolas
  Scrapers::Stores::NicolasJob.new.run
end

