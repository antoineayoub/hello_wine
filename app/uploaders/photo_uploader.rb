# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  version :standard do
    resize_to_fill 400, 300
  end

  version :thumb do
    resize_to_fill 100, 100
  end

end
