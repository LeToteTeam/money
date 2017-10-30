# Parse an amount from a string
class MoneyParser
  MARKS = "\.,·’"
  EXTRA_MARKS = "\s˙'"

  def self.parse(input, currency = nil)
    new.parse(input, currency)
  end

  def parse(input, currency = nil)
    Money.new(extract_money(input.to_s, currency), currency)
  end

  private

  def extract_money(input, currency = nil)
    return '0' if input.to_s.empty?

    amount = input.scan(/(-?[\d#{MARKS}][\d#{MARKS}#{EXTRA_MARKS}]*)/).first
    return '0' unless amount
    amount = amount.first.tr(EXTRA_MARKS, '')

    *other_marks, last_mark = amount.scan(/[#{MARKS}]/)
    other_marks.uniq!

    return amount if last_mark.nil?

    *dollars, cents = amount.split(last_mark)
    dollars = dollars.join.tr(MARKS, '')

    if cents.size > 2
      c = Money::Helpers.value_to_currency(currency)

      if (!dollars.to_i.zero? && c.decimal_mark != last_mark) || other_marks == [last_mark]
        return "#{dollars}#{cents}"
      end
    end

    "#{dollars}.#{cents}"
  end
end
