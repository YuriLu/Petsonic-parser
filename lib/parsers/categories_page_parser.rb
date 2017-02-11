require_relative './parser.rb'

# Класс для получения урлов всех продуктов с определенной страницы
class CategoriesPageParser < Parser
  attr_reader :categories_links

  # Xpath для урла страницы с продуктом
  PRODUCT_LINK_XPATH = "//div[contains(@class, 'productlist')]"\
                       "//div[contains(@class, 'product-container')]"\
                       "//a[contains(@class, 'product_img_link')]"\
                       "//@href".freeze

  # Получает урлы всех продуктов с определенной страницы
  def parse
    @categories_links = parse_by_xpath(PRODUCT_LINK_XPATH).map(&:value)
  end
end
