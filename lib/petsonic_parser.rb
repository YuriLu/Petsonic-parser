require_relative './parsers/categories_pages_parser.rb'
require_relative './parsers/product_page_parser.rb'
require_relative './csv/products_to_csv.rb'

class PetsonicParser
  attr_reader :url, :file

  def initialize(url:, file:)
    @url = url
    @file = file
  end

  def process
    # Получает урлы всех товаров в категории
    parser = CategoriesPagesParser.new(url)
    parser.parse

    # Парсит страницу каждого товара и извелекает с нее необходимую инфу
    products = parser.categories_links.map do |link|
      pp = ProductPageParser.new(link)
      pp.parse
      pp.product_info
    end

    # Записывает всю инфу в csv файл
    ProductsToCsv.new(file, products).to_csv
  end
end
