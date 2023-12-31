defmodule ThreemaGateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :threema_gateway,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:telemetry, "~> 1.0"},
      {:enacl, github: "hdahlheim/enacl", ref: "crypto_box_easy"},
      {:jason, "~> 1.4"},
      {:req, "~> 0.3.11", optional: true},
      {:json_struct, github: "hdahlheim/json_struct", ref: "main"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
