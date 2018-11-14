# MegaXml

**Creates an Elixir Map data structure from an XML string or file (either potentially very large; it uses chunking and `StringIO`) without any configuration**

## Usage

```elixir
MegaXml.parse("<foo><bar>123</bar></foo>")
```

Results:

```elixir
%{"foo" => %{"bar" => "123"}}
```

Depends on Erlsom to parse the xml via its SAX event-driven mode which then builds a deeply-nested map/array data structure.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mega_xml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mega_xml, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mega_xml](https://hexdocs.pm/mega_xml).

