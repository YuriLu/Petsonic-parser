require 'curb'
require 'nokogiri'

require_relative '../errors/not_parsed_error.rb'

# Родительский класс для всех парсеров
class Parser
  attr_reader :url, :html

  def initialize(url)
    @url = url
  end

  protected

  # Если нету html бросает кастомную ошибку
  def html
    @html || parse_html
    raise NotParsedError unless @html
    @html
  end

  def parse_by_xpath(xpath)
    html.xpath(xpath)
  end

  private

  # Скачивает html с урла и првращает его в nokogiri объект
  def parse_html
    http = Curl.get(@url)
    @html = Nokogiri::HTML(http&.body)
  end
end
