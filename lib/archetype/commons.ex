defmodule Archetype.Commons do
  @moduledoc ~S"""
  Common functions shared across most types.
  """

  import Archetype.Helpers, only: [typeof: 1]

  @doc ~S"""
  Alias to `Archetype.Issue.from/2`.
  """
  @spec issue(text_template, ctx) :: Archetype.Issue.t()
        when text_template: String.t(),
             ctx: map

  defdelegate issue(template, ctx \\ %{}), to: Archetype.Issue, as: :from

  @doc ~S"""
  Validates that the given value is not `nil`.
  """
  @spec validate_required(term) :: :ok | {:error, [Archetype.Issue.t(), ...]}

  def validate_required(nil), do: {:error, [issue("is required")]}
  def validate_required(_, _), do: :ok

  @doc ~S"""
  Validates that the given value matches the expected type.
  """
  @spec validate_type(term, String.t()) :: :ok | {:error, [Archetype.Issue.t(), ...]}

  def validate_type(value, <<_, _::binary>> = expected_type) do
    ctx = %{
      expected: expected_type,
      actual: typeof(value)
    }

    case ctx.expected == ctx.actual do
      true -> :ok
      false -> {:error, [issue("expected type {{expected}}, got {{actual}}", ctx)]}
    end
  end
end
