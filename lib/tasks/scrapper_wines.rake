require 'scrapers/wines/monoprix'
require 'scrapers/wines/nicolas'

desc "Scraper Wines"
task :scraper_wines => [:environment] do
  puts "What would you like to scrap ?"
  puts "1- Nicolas"
  puts "2- Monoprix"
  puts "3- All"
  puts "4- Exit"

  result = STDIN.gets.chomp.to_i

  if result == 1
    wine_scraper_nicolas
  elsif result == 2
    wine_scraper_monoprix
  elsif result == 3
    wine_scraper_nicolas
    wine_scraper_monoprix
  else
    exit
  end
end

def wine_scraper_monoprix
  Scrapers::Wines::Monoprix.new.run
end

def wine_scraper_nicolas
  Scrapers::Wines::Nicolas.new.run
end

# CODE TO DELETE FOLDERS AWS S3
# require 'aws-sdk'
#  s3 = Aws::S3::Resource.new

#   # reference an existing bucket by name
#   bucket = s3.bucket(ENV["AWS_S3_BUCKET_NAME"])


#   # delete all of the objects in a bucket (optionally with a common prefix as shown)
#   bucket.objects(prefix: 'uploads/Wine/').batch_delete!

