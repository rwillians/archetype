defmodule Archetype.Locale do
  @moduledoc ~S"""
  Behaviour for internationalization modules.
  """

  @doc ~S"""
  """
  @callback t(text :: String.t()) :: String.t()

  @typedoc ~S"""
  """
  @type t() :: module()

  @doc ~S"""
  """
  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
    end
  end
end
