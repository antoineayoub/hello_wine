require 'scrapers/vivino'

module Scrapers
  class VivinoJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      puts "ok"
      ActiveRecord::Base.transaction do
        Scrapers::Vivino.new.run
        puts "ok"
      end
    end
  end
end

