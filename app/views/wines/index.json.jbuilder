json.wines do
  json.array! @wines do |wine|
    json.extract! wine[:wine].na, :name
  end
end
