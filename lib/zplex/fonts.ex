defmodule Zplex.Fonts do
  @fonts %{
    a: %{width: 15, height: 15},
    b: %{width: 20, height: 20},
    c: %{width: 30, height: 30},
    d: %{width: 40, height: 40},
  }

  def get_dimensions(font), do: @fonts[font]
end
