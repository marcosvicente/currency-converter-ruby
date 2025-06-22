class CurrencyEnumeration < EnumerateIt::Base
  associate_values(
    :BRL,
    :USD,
    :EUR,
    :JPY
  )
end
