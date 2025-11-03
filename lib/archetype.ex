defmodule Archetype do
  @moduledoc ~S"""
  A schema validator and parser heavely inspired by TypeScript's
  [ArkType](https://arktype.io).
  """

  defdelegate parse(type, value, opts \\ []), to: Archetype.Type, as: :parse

  @doc ~S"""
  Defines a new string type.

      Z.string()

  ## Examples

      iex> Z.string()
      iex> |> Z.parse("Hello, World!")
      {:ok, "Hello, World!"}

  You can trim the input string before validation by setting the
  `:trim` option to `true`:

      iex> Z.string(trim: true)
      iex> |> Z.parse("   Hello, World!   ")
      {:ok, "Hello, World!"}

  You can set the exact expected length of the string by using the
  `:length` option:

      iex> Z.string(length: 5)
      iex> |> Z.parse("Hello")
      {:ok, "Hello"}

      iex> Z.string(length: 5)
      iex> |> Z.parse("Hello, World!")
      {:error, [%Archetype.Issue{
        path: [],
        template: "must be exactly {{expected}} {{expected -> character/characters}} long",
        ctx: %{actual: 13, expected: 5}
      }]}

  """
  defdelegate string(opts \\ []), to: Archetype.Type.String, as: :new
end
