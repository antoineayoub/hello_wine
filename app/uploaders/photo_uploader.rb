# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s}"
  end
  version :standard do
    resize_to_fill 400, 300
  end

  version :thumb do
    resize_to_fill 100, 100
  end

end
