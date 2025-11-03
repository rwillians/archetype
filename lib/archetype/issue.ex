defmodule Archetype.Issue do
  @moduledoc ~S"""
  Represents an issue found during validation.
  """

  import Archetype.Helpers, only: [i: 1, to_atom: 1]

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
  def message(%Archetype.Issue{} = issue, opts) when is_list(opts) do
    locale = Keyword.get(opts, :locale, @locale)
    template = apply(locale, :t, [issue.template])

    template
    |> replace_pluralize_slots!(issue.ctx)
    |> replace_variables(issue.ctx)
  end

  @doc ~S"""
  Creates a new issue.
  """
  @spec from(template, ctx) :: t
        when template: String.t(),
             ctx: map

  def from(template, ctx \\ %{})

  def from(<<_, _::binary>> = template, %{} = ctx)
      when is_non_struct_map(ctx),
      do: %Archetype.Issue{template: template, ctx: ctx}

  #
  #   PRIVATE
  #

  @pattern ~r/\{\{([^\s]+)\s+\-\>\s+([^\s\/]+)\s{0,}\/\s{0,}([^\}]+)\}\}/
  defp replace_pluralize_slots!(<<_, _::binary>> = template, %{} = ctx) do
    Regex.replace(@pattern, template, fn _, count_field, singular, plural ->
      case Map.fetch(ctx, to_atom(count_field)) do
        {:ok, n} when n in [1, 1.0] -> singular
        {:ok, n} when is_number(n) -> plural
        {:ok, %Decimal{} = n} -> if(Decimal.eq?(n, 1), do: singular, else: plural)
        {:ok, value} -> raise(ArgumentError, "Expected the value of field :#{count_field} to be a number or Decimal, got #{i(value)}")
        _ -> raise(ArgumentError, "The field :#{count_field} doesn't exist in the issue's context map")
      end
    end)
  end

  defp replace_variables(<<_, _::binary>> = template, %{} = ctx) do
    Enum.reduce(ctx, template, fn {key, value}, acc ->
      String.replace(acc, "{{#{key}}}", to_string(value))
    end)
  end
end
