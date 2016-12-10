math.sign = (n) ->
  return -1 if n < 0
  return 1  if n > 0

  0

math.lerp = (a, b, t) ->
  (1 - t) * a + t * b

require "kit"
