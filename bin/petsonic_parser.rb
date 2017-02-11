require 'optparse'

require_relative '../lib/petsonic_parser.rb'

# Cохраняет все переданные параметры в хэш(url и файл)
options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: petsonic_parser.rb -u[--url] url -f[--file] file_path'

  opts.on('-u [URL]', '--url', 'Specify url') do |url|
    options[:url] = url
  end

  opts.on('-f [FILE]', '--file', 'Specify file') do |file|
    options[:file] = file
  end

  opts.on('-h', '--help', 'Help') do
    puts opts
    exit
  end
end.parse!

unless options[:url]
  puts 'Url required'
  exit
end

unless options[:file]
  puts 'File required'
  exit
end

PetsonicParser.new(url: options[:url], file: options[:file]).process
