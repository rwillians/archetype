defmodule Archetype.Locale do
  @moduledoc ~S"""
  Behaviour for internationalization modules.
  """

  @doc ~S"""
  Translates the given template string.
  """
  @callback t(template :: String.t()) :: String.t()

  @typedoc ~S"""
  Any module that implements the `Archetype.Locale` behaviour.
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
