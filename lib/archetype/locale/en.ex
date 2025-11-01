defmodule Archetype.Locale.En do
  @moduledoc ~S"""
  English translations.
  """

  use Archetype.Locale

  @impl Archetype.Locale
  def t(<<_, _::binary>> = text), do: text
end
