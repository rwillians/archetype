# Archetype

**Archetype** is a schema validator and parser heavely inspired by
TypeScript's [ArkType](https://arktype.io).

```elixir
use Archetype

@schema type(%{
          name: type("1 <= string <= 100"),
          age: type("(integer >= 18) | nil"),
          email: type("string.email | nil"),
          phone: type("string.phone | nil"),
          last_contacted_at: type("DateTime.t() | nil")
        })

@type t() :: unquote(Archetype.to_spec(@schema))

case Archetype.parse(@schema, conn.body_params) do
  {:ok, params} ->
    Logger.info("Valid params: #{inspect(params)}")

  {:error, issues} ->
    Logger.error("Failed validation: #{inspect(Archetype.to_errors_by_field(issues))}")
end
```

See the full [documentation](https://hexdocs.pm/archetype/Archetype.html) at hexdocs.


## Installation

You can install this package by adding `archetype` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:archetype, "~> 0.1"}
  ]
end
```
