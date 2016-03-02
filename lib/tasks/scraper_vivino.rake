require 'scrapers/vivino'

desc "Scrappe Vivino"
task :scraper_vivino => [:environment] do
   Scrapers::VivinoJob.perform_later
end
