defmodule Archetype.Issue do
  @moduledoc ~S"""
  Represents an issue found during validation.
  """

  @typedoc ~S"""
  """
  @type t() :: %Archetype.Issue{
          path: [atom | String.t()],
          template: String.t(),
          ctx: map
        }

  defstruct path: [],
            template: "",
            ctx: %{}

  @doc ~S"""
  """
  @spec message(t, [option]) :: String.t()
        when option: {:locale, Archetype.Locale.t()}

  def message(type, opts \\ [])

  @locale Application.compile_env(:archetype, :locale, Archetype.Locale.En)
  def message(%Archetype.Issue{} = issue, opts) do
    locale = Keyword.get(opts, :locale, @locale)
    template = apply(locale, :t, [issue.template])

    # @TODO replace slots
    template
  end

  @doc ~S"""
  Creates a new issue.
  """
  @spec issue(String.t(), map) :: t

  def issue(text, ctx \\ %{})

  def issue(<<_, _::binary>> = text, ctx)
      when is_non_struct_map(ctx),
      do: %Archetype.Issue{template: text, ctx: ctx}
end
