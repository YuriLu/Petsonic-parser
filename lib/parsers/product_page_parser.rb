require_relative '../../ext/string.rb'

# Класс для полученя заданной инфы о продукте
class ProductPageParser < Parser
  attr_reader :product_name, :product_weights_prices, :product_image

  # Xpath для названия продукта
  NAME_XPATH = "//h1[contains(@itemprop, 'name')]//text()".freeze

  # Xpath для блока с весами и ценами
  WEIGHTS_PRICES_XPATH = "//div[contains(@class, 'attribute_list')]"\
                         "//ul[contains(@class, 'attribute_labels_lists')]"\
                         "//li".freeze

  # Xpath для отдельного веса
  WEIGHT_XPATH = "span[contains(@class, 'attribute_name')]".freeze
  # Xpath для отдельной цены
  PRICE_XPATH = "span[contains(@class, 'attribute_price')]".freeze
  # Еще один xpath для цены, так как на некоторых страницах предыдущий не сработакет(немного другая структура страницы)
  PRICE_XPATH_OPTIONAL = "//span[@id='price_display']".freeze

  # Xpath для картинки
  IMAGE_XPATH = "//img[@id='bigpic']"\
                "//@src".freeze


  def parse
    parse_product_name
    parse_product_weights_prices
    parse_image
  end

  def product_info
    {
      name: product_name,
      weights_prices: product_weights_prices,
      image: product_image,
      url: url
    }
  end

  private

  # Парсит название продукта
  def parse_product_name
    @product_name = parse_by_xpath(NAME_XPATH).last&.text&.squish
  end

  # Парсит вес продукта с соответстующей ценой
  def parse_product_weights_prices
    # Парсит все блоки с инфой вес-цена и для каждого блока берет отдельно вес и цену
    @product_weights_prices = parse_by_xpath(WEIGHTS_PRICES_XPATH).map do |info|
      {
        weight: info.at_xpath(WEIGHT_XPATH)&.text&.squish,
        price: info.at_xpath(PRICE_XPATH)&.text&.squish
      }
    end

    # Если ничего не распарсило то пробуем дополнительный xpath, по нему определяем только цену
    if @product_weights_prices.empty?
      price = parse_by_xpath(PRICE_XPATH_OPTIONAL).first&.text&.squish

      if price
        @product_weights_prices = [{ weight: nil, price: price }]
      end
    end
  end

  # Парсит картинку продукта
  def parse_image
    @product_image = parse_by_xpath(IMAGE_XPATH).first&.value
  end
end
