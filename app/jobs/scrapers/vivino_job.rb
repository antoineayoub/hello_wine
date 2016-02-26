require 'scrapers/vivino'

module Scrapers
  class VivinoJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      Scrapers::Vivino.new.run
    end
  end
end

