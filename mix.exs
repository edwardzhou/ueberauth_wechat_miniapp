defmodule Ueberauth.Wechat.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :ueberauth_wechat,
     version: @version,
     name: "Ueberauth Wechat",
     package: package(),
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/sllt/ueberauth_wechat",
     homepage_url: "https://github.com/sllt/ueberauth_wechat",
     description: description(),
     deps: deps(),
     docs: docs()]
  end

  def application do
    [applications: [:logger, :ueberauth, :oauth2]]
  end

  defp deps do
    [
     {:oauth2, "~> 0.9"},
     {:ueberauth, "~> 0.4"},
     {:poison, "~> 3.1"},
     # dev/test only dependencies
     {:credo, "~> 0.8", only: [:dev, :test]},

     # docs dependencies
     {:earmark, ">= 0.0.0", only: :dev},
     {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp docs do
    [extras: ["README.md"]]
  end

  defp description do
    "An Ueberauth strategy for using Wechat to authenticate your users."
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["sllt"],
      licenses: ["MIT"],
      links: %{"GitHub": "https://github.com/sllt/ueberauth_wechat"}]
  end
end
