defmodule Archetype.Notation do
  @moduledoc ~S"""
  This module provides the ArkType-like syntax for describing types.
  """

  defmacro type(ast), do: compile(ast)

  #
  #   PRIVATE
  #

  defp compile("string"), do: quote(do: %Archetype.String{})
end
