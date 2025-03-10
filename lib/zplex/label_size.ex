defmodule Zplex.LabelSize do
  @doc """
  Convert label dimensions to dots for specific DPI
  Example sizes: {4, :inch, 6, :inch}, {100, :mm, 150, :mm}
  """
  def convert({w_val, w_unit, h_val, h_unit}, dpi) do
    w = convert_unit(w_val, w_unit, dpi)
    h = convert_unit(h_val, h_unit, dpi)
    %{width: w, height: h}
  end

  defp convert_unit(val, :inch, dpi), do: (val * dpi) |> round()
  defp convert_unit(val, :mm, dpi), do: (val / 25.4 * dpi) |> round()
end
