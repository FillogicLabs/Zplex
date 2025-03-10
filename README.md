# Zplex

`Zplex` is a library for generating ZPL labels. It provides a DSL for defining ZPL templates and a generator for rendering them.

ZPL (Zebra Programming Language) is used to format content for printing with Zebra printers. This library makes it easier to create 
and maintain ZPL labels in Elixir.

Using the DSL provided you can define templates by passing a name and label size parameters to the template macro. Elements are then
defined in the template block. Currently `Zplex` supports text and multiple barcode elements. Elements can be position using absolute
or relative positioning. You can define the position using mm or inch units and the library will handle the conversion to the correct
units for the printer. You can autoscale your templates to either 203 or 300 dpi by passing the correct dpi parameter to the template.

The library also supports different scalable font types. The default font is `a` which is 15x15 units. You can use the `b`, `c`, and `d`
fonts which are 20x20, 30x30, and 40x40 units respectively.

## Usage

First define your ZPL templates

```
defmodule MyTemplates do
  import Zplex.TemplateDSL

  template :shipping_label, label_size: {4, :inch, 6, :inch} do
    text :name, font: :a, position: {:absolute, x: {:mm, 10}, y: {:mm, 5}},  align: :left
    text :address, font: :b, position: {:relative, :below, offset: {:mm, 2}}
    barcode :tracking_number, position: {:relative, :below, offset: {:mm, 5}}, height: 50, type: :code128
  end
end

```

Then you can use your template with dynamic data and DPI

```
data = %{name: "Alice", address: "123 Maple St", tracking_number: "123456789"}

zpl_203dpi = MyTemplates.shipping_label(data, 203)
zpl_300dpi = MyTemplates.shipping_label(data, 300)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `zplex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:zplex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/zplex>.

