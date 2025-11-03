defmodule Archetype.Helpers do
  @moduledoc false

  import Keyword, only: [keyword?: 1]

  @doc ~S"""
  Alias to `Kernel.inspect/1`.
  """
  @spec i(any) :: String.t()

  def i(value), do: inspect(value)

  @doc ~S"""
  Casts the given value to an atom.

      iex> to_atom(:example)
      :example

      iex> to_atom("example")
      :example

      iex> to_atom("asdfadsf")
      :asdfadsf

  """
  @spec to_atom(atom | String.t()) :: atom

  def to_atom(value) when is_atom(value), do: value

  def to_atom(<<_, _::binary>> = value) do
    String.to_existing_atom(value)
  rescue
    _ -> String.to_atom(value)
  end

  @doc ~S"""
  Returns the module name as a string without the "Elixir." prefix.

      iex> to_mod_name(Archetype.Type.String)
      "Archetype.Type.String"

      iex> to_mod_name(Elixir.Archetype.Type.String)
      "Archetype.Type.String"

  """
  def to_mod_name(mod)
      when is_atom(mod),
      do: String.trim_leading(to_string(mod), "Elixir.")

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
end
