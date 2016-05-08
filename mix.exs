defmodule Manju.Mixfile do
  use Mix.Project

  def project do
    [app: :manju,
     version: "0.0.1",
     elixir: "~> 1.1",
     compilers: Mix.compilers ++ [:manju],
     escript: [main_module: Manju],
     docs: [readme: true, main: "README.md"],
     description: """
     Manju is a simple OOP, dynamically typed, functional language that runs on the Erlang virtual machine (BEAM).
     Manju's sytnax is Python-like syntax.
     """,
     deps: deps]
  end

  defp deps do
    []
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Yasushi Itoh"],
      links: %{ "GitHub" => "https://github.com/i2y/manju" }
    }
  end
end
