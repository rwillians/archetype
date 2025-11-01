# Archetype

**Archetype** is a schema validator and parser heavely inspired by
TypeScript's [Zod](https://zod.dev) and [ArkType](https://arktype.io).

## Usage

Zod-like API:

```elixir
alias Archetype, as: Z

@schema Z.map(%{
          name: Z.string() |> Z.min(1) |> Z.max(100),
          age: Z.integer() |> Z.min(18) |> Z.optional(),
          email: Z.email() |> Z.optional(),
          phone: Z.numeric() |> Z.optional(),
          last_contacted_at: Z.datetime() |> Z.optional()
        })

@type t() :: unquote(Z.to_spec(@schema))

Z.parse(@schema, conn.body_params)
```

ArkType-like API:

```elixir
use Archetype

@schema type(%{
          name: type("1 <= string <= 100"),
          age: type("(integer >= 18) | nil"),
          email: type("string.email | nil"),
          phone: type("string.numeric | nil"),
          last_contacted_at: type("DateTime.t() | nil")
        })

@type t() :: unquote(Archetype.to_spec(@schema))

Archetype.parse(@schema, conn.body_params)
```

See the full [documentation](https://hexdocs.pm/archetype) at hexdocs.


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
