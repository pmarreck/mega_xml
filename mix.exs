defmodule MegaXml.MixProject do
  use Mix.Project

  def project do
    [
      app: :mega_xml,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "MegaXml",
      source_url: "https://github.com/pmarreck/mega_xml"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:erlsom, git: "git@github.com:willemdj/erlsom.git"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
    ]
  end

  defp description() do
    "Creates an Elixir Map data structure from an XML string or file (either potentially very large; it uses chunking and StringIO) without any configuration."
  end

  defp package() do
    [
      licenses: ["EUPL-1.2"],
      links: %{"GitHub" => "https://github.com/pmarreck/mega_xml"}
    ]
  end
end
