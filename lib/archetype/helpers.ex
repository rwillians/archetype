defmodule Archetype.Helpers do
  @moduledoc false

  import Keyword, only: [keyword?: 1]

  @doc false
  defdelegate issue(text, ctx \\ %{}), to: Archetype.Issue

  @doc false
  def to_mod_name(mod)
      when is_atom(mod),
      do: String.replace(to_string(mod), ~r/^Elixir\./, "")

  @doc false
  def typeof(nil), do: "nil"
  def typeof(value) when is_atom(value), do: "atom"
  def typeof(value) when is_binary(value), do: "string"
  def typeof(value) when is_bitstring(value), do: "bitstring"
  def typeof(value) when is_boolean(value), do: "boolean"
  def typeof(value) when is_float(value), do: "float"
  def typeof(value) when is_integer(value), do: "integer"
  def typeof(value) when is_list(value), do: if(keyword?(value), do: "keyword", else: "list")
  def typeof(%mod{}), do: "%#{to_mod_name(mod)}{}"
  def typeof(%{__struct__: mod}), do: "%#{to_mod_name(mod)}{}"
  def typeof(value) when is_map(value), do: "map"
  def typeof(value) when is_tuple(value), do: "tuple"
  def typeof(value) when is_function(value), do: "function"
  def typeof(value) when is_pid(value), do: "pid"
  def typeof(value) when is_port(value), do: "port"
  def typeof(value) when is_reference(value), do: "reference"

  @doc false
  def validate_required(nil), do: {:error, issue("is required")}

  @doc false
  def validate_type(value, expected_type) do
    ctx = %{
      expected: to_string(expected_type),
      actual: typeof(value)
    }

    case ctx.expected == ctx.actual do
      true -> :ok
      false -> {:error, issue("expected type {{expected}}, got {{actual}}", ctx)}
    end
  end
end
