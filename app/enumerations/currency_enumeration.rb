class CurrencyEnumeration < EnumerateIt::Base
  associate_values(
    :usd,
    :brl,
    :eur,
    :jyp
  )
end
