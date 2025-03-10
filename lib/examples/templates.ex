defmodule Zplex.Templates do
  @moduledoc """
  Example templates for generating ZPL labels.
  """

  use Zplex

  template :shipping_label, label_size: {4, :inch, 6, :inch} do
    element(text(:name, font: :a, position: {:absolute, x: {:mm, 10}, y: {:mm, 5}}, align: :left))
    element(text(:address, font: :b, position: {:relative, :below, offset: {:mm, 2}}))

    element(
      barcode(:tracking_number,
        position: {:relative, :below, offset: {:mm, 5}},
        height: 50,
        format: :code128
      )
    )
  end

  template :upc_tag, label_size: {1.5, :inch, 1, :inch} do
    element(
      text(:description, font: :b, position: {:absolute, x: {:mm, 2}, y: {:mm, 1}}, align: :left)
    )

    element(text(:style, font: :b, position: {:absolute, x: {:mm, 2}, y: {:mm, 4}}, align: :left))

    element(
      text(:size, font: :b, position: {:absolute, x: {:inch, 1.35}, y: {:mm, 1}}, align: :right)
    )

    element(
      text(:color, font: :b, position: {:absolute, x: {:inch, 1.35}, y: {:mm, 4}}, align: :right)
    )

    element(
      barcode(:upc,
        position: {:absolute, x: {:inch, 0.30}, y: {:inch, 0.35}},
        height: 10,
        format: :upc_a
      )
    )

    element(
      text(:footer_1, font: :a, position: {:absolute, x: {:mm, 2}, y: {:inch, 0.85}}, align: :left)
    )

    element(
      text(:footer_2, font: :a, position: {:absolute, x: {:mm, 2}, y: {:inch, 0.95}}, align: :left)
    )
  end
end
