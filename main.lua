math.sign = function(n)
  if n < 0 then
    return -1
  end
  if n > 0 then
    return 1
  end
  return 0
end
return require("kit")
