def declination(number, first, second, third)
  ostatok = number % 10

  number = number % 100
  if number >= 11 && number <= 14
    return third
  end

  if ostatok == 1
    return first
  end

  if ostatok >= 2 && ostatok <= 4
    return second
  end

  if (ostatok > 4 && ostatok <= 9) || ostatok == 0
    return third
  end
end

puts declination(18457, "крокодил", "крокодила", "крокодилов")