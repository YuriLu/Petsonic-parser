require_relative './parser.rb'
require_relative './categories_page_parser.rb'

# Класс для получения урлов всех продуктов в категории
class CategoriesPagesParser < Parser
  attr_reader :categories_links

  # Xpath для максимальной страницы в пагинации
  MAX_PAGE_XPATH = "//ul[contains(@class, 'pagination')]"\
                   "//li[last() - 1]"\
                   "//span".freeze

  # Первая страница в пагинации
  FIRST_PAGINATION_PAGE = 1
  # Максимально допустимое на сайте количество продуктов на одной странице
  MAX_PRODUCTS_ON_PAGE = 100

  def initialize(url)
    # Для отображения продуктов на странице по 100(чтобы было меньше страниц)
    url = "#{url}?n=#{MAX_PRODUCTS_ON_PAGE}"
    super
  end

  # Итерирует по всем страницам со списком продуктов и получает урлы продуктов с каждой страницы
  def parse
    @categories_links = pagination_pages_urls.inject([]) do |arr, url|
      # Получает урлы продуктов с определенной страницы
      parser = CategoriesPageParser.new(url)
      parser.parse
      arr + parser.categories_links
    end
  end

  private

  # Парсит максимальную страницу в пагинации
  def parse_max_page
    @max_page ||= parse_by_xpath(MAX_PAGE_XPATH).first&.text&.to_i || 1
  end

  # Получает урлы всех страниц(передает GET параметр `p`)
  def pagination_pages_urls
    (FIRST_PAGINATION_PAGE..parse_max_page).to_a.map { |page| "#{@url}&p=#{page}" }
  end
end
