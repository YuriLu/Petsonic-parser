require 'csv'

class ProductsToCsv
  attr_reader :file, :products

  HEADERS = %w(name price image url).freeze

  def initialize(file, products)
    @file = file
    @products = products
  end

  # Записывает все инфу в заданный csv файл в необходимом формате
  def to_csv
    CSV.open(file, 'w') do |csv|
      csv << HEADERS

      products.each do |product|
        name = product[:name] || 'NA'
        image = product[:image] || 'NA'
        url = product[:url] || 'NA'

        if product[:weights_prices].any?
          product[:weights_prices].each do |weight_price|
            name = "#{product[:name]} - #{weight_price[:weight]}" if weight_price[:weight]
            price = weight_price[:price] || 'NA'

            csv << [name, price, image, url]
          end
        else
          csv << [name, 'NA', image, url]
        end
      end
    end
  end
end
