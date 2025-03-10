defmodule Zplex do
  @moduledoc """
  `Zplex` is a library for generating ZPL labels. It provides a DSL for defining ZPL templates and a generator for rendering them.

  ZPL (Zebra Programming Language) is used to format content for printing with Zebra printers.
  This library makes it easier to create and maintain ZPL labels in Elixir.
  """

  alias Zplex.{Generator, LabelSize}

  defmacro template(name, [label_size: size], do: block) do
    quote do
      Module.delete_attribute(__MODULE__, :elements)
      Module.register_attribute(__MODULE__, :elements, accumulate: true)
      unquote(block)
      def unquote(name)(data, dpi) do
        elements = __elements__()
        label_dims = LabelSize.convert(unquote(size), dpi)
        Generator.generate(elements, data, dpi, label_dims)
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Zplex
      Module.register_attribute(__MODULE__, :elements, accumulate: true)
      @before_compile Zplex
    end
  end

  defmacro element(expr) do
    quote do
      Module.put_attribute(__MODULE__, :elements, unquote(expr))
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def __elements__(), do: @elements
    end
  end

  defmacro text(data_key, opts) do
    quote do
      %{
        type: :text,
        data_key: unquote(data_key),
        font: Keyword.get(unquote(opts), :font),
        position: Keyword.get(unquote(opts), :position),
        align: Keyword.get(unquote(opts), :align, :left)
      }
    end
  end

  defmacro barcode(data_key, opts) do
    quote do
      %{
        type: :barcode,
        data_key: unquote(data_key),
        position: Keyword.get(unquote(opts), :position),
        format: Keyword.get(unquote(opts), :format, :code128),
        height: Keyword.get(unquote(opts), :height)
      }
    end
  end
end
