class MoneyParser
  # parse a amount from a string
  def self.parse(input, currency = nil)
    new.parse(input, currency)
  end

  def parse(input, currency = nil)
    Money.new(extract_money(input.to_s), currency)
  end

  private
  def extract_money(input)
    return Money.zero if input.to_s.empty?

    amount = input.scan(/\-?[\d\.\,]+/).first

    return Money.zero if amount.nil?

    # Convert 0.123 or 0,123 into what will be parsed as a decimal amount 0.12 or 0.13
    amount.gsub!(/^(-)?(0[,.]\d\d)\d+$/, '\1\2')

    segments = amount.scan(/^(.*?)(?:[\.\,](\d{1,2}))?$/).first

    return Money.zero if segments.empty?

    amount   = segments[0].gsub(/[^-\d]/, '')
    decimals = segments[1].to_s.ljust(2, '0')

    "#{amount}.#{decimals}"
  end
end
