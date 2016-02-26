require 'scrapers/vivino'

desc "Scrappe Vivino"
task :scraper_vivino => [:environment] do
   Scrapers::Vivino.new.run
end
