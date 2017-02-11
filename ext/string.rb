class String
  # Удаляет с многострочного стринга все пробельные символы
  def squish
    gsub(/\A[[:space:]]+/, '')
    .gsub(/[[:space:]]+\z/, '')
    .gsub(/[[:space:]]+/, ' ')
  end
end
