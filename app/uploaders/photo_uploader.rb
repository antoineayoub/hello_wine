# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s}"
  end
  # version :standard do
  #   resize_to_fit 200, 400
  # end

  # version :thumb do
  #   resize_to_fit 100, 200
  # end

end
