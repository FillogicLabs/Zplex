defmodule Zplex.Generator do
  alias Zplex.{Fonts, UnitConverter}

  def generate(elements, data, dpi, label_dims) do
    initial_state = %{
      x: 0,
      y: 0,
      dpi: dpi,
      label_width: label_dims.width,
      label_height: label_dims.height,
      zpl: []
    }

    {state, _} = Enum.reduce(elements, {initial_state, nil}, &process_element(&1, &2, data))

    (["^XA"] ++ state.zpl ++ ["^XZ"]) |> Enum.join("\n")
  end

  defp process_element(element, {state, _prev}, data) do
    {new_state, zpl} =
      case element.type do
        :text -> generate_text(element, state, data)
        :barcode -> generate_barcode(element, state, data)
      end

    {new_state, zpl}
  end

  defp generate_text(
         %{
           data_key: key,
           font: font,
           position: pos,
           align: align
         },
         state,
         data
       ) do
    text = Map.get(data, key, "")

    %{width: cw, height: ch} = Fonts.get_dimensions(font)

    width = String.length(text) * (cw * 0.27)

    {x, y} = calc_position(pos, state, width, ch)

    x =
      case align do
        :left -> x
        :right -> x - width
        :center -> x - div(width, 2)
      end

    zpl = "^FO#{x},#{y}^A0,#{cw},#{ch}^FD#{text}^FS"

    {%{state | x: x + width, y: y + ch, zpl: state.zpl ++ [zpl]}, zpl}
  end

  defp generate_barcode(%{data_key: key, height: h, position: pos, format: format}, state, data) do
    code = Map.get(data, key, "")

    {x, y} = calc_position(pos, state, 0, h)

    {barcode_width, barcode_height} = case state.dpi do
      300 -> {3, 100}
      203 -> {2, 75}
    end

    zpl = case format do
      :code128 -> "^FO#{x},#{y}^BC^FD#{code}^FS"
      :upc_a -> "^FO#{x},#{y}^BY#{barcode_width}^BUN,#{barcode_height}^FD#{code}^FS"
    end

    {%{state | x: x, y: y + h, zpl: state.zpl ++ [zpl]}, zpl}
  end

  defp calc_position({:absolute, x: x_unit, y: y_unit}, state, w, h) do
    x = convert_unit(x_unit, state.dpi)
    y = convert_unit(y_unit, state.dpi)

    # Check if element fits within label boundaries
    if x + w > state.label_width or y + h > state.label_height do
      raise "Element exceeds label boundaries"
    end

    {x, y}
  end

  defp calc_position({:relative, direction, offset: off}, state, w, h) do
    case direction do
      :below ->
        new_y = state.y + h + convert_unit(off, state.dpi)

        if new_y + h > state.label_height do
          raise "Vertical space exhausted on label"
        end

        {state.x, new_y}

      :right ->
        new_x = state.x + w + convert_unit(off, state.dpi)

        if new_x + w > state.label_width do
          raise "Horizontal space exhausted on label"
        end

        {new_x, state.y}
    end
  end

  defp convert_unit({:mm, val}, dpi), do: UnitConverter.mm_to_dots(val, dpi)
  defp convert_unit({:inch, val}, dpi), do: UnitConverter.inch_to_dots(val, dpi)
  defp convert_unit(val, _dpi) when is_integer(val), do: val
end
