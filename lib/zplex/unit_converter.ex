defmodule Zplex.UnitConverter do
  @mm_per_inch 25.4

  def mm_to_dots(mm, dpi), do: (mm / @mm_per_inch * dpi) |> round()
  def inch_to_dots(inch, dpi), do: (inch * dpi) |> round()
end
