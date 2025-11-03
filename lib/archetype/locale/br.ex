defmodule Archetype.Locale.Br do
  @moduledoc ~S"""
  Brazilian Portuguese translations.
  """

  use Archetype.Locale

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  #                        COMMON VALIDATORS                        #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  @impl Archetype.Locale
  def t("is required"), do: "campo obrigatório"
  def t("cannot be empty"), do: "não pode estar vazio"

  def t("expected type {{expected}}, got {{actual}}"),
    do: "era esperado um valor do tipo {{expected}} mas recebeu {{actual}}"


  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  #                      Archetype.Type.String                      #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  def t("must be exactly {{expected}} {{expected -> character/characters}} long"),
    do: "deve ter exatamente {{expected}} {{expected -> caractere/caracteres}} de comprimento"

  def t("must be at least {{expected}} {{expected -> character/characters}} long"),
    do: "deve ter pelo menos {{expected}} {{expected -> caractere/caracteres}} de comprimento"

  def t("must be at most {{expected}} {{expected -> character/characters}} long"),
    do: "deve ter no máximo {{expected}} {{expected -> caractere/caracteres}} de comprimento"
end
