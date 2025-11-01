defmodule Archetype.Option do
  @moduledoc ~S"""
  Stores metadata about an option of a type.
  """

  @typedoc ~S"""
  Represents an option in a type, with the option's value and an error
  message.
  """
  @type t(value_type) :: %Archetype.Option{
          value: value_type,
          error: String.t()
        }

  @typedoc ~S"""
  """
  @type t() :: t(any())

  defstruct value: nil,
            error: nil

  @doc ~S"""
  """
  @spec new(value, opts, overrides) :: t
        when value: any,
             opts: keyword,
             overrides: keyword

  def new(value, opts, overrides \\ []),
    do: struct!(__MODULE__, [{:value, value}] ++ Keyword.merge(opts, overrides))
end
