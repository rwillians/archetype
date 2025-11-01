defmodule Archetype.String do
  @moduledoc ~S"""
  Describes a string type.
  """

  import Kernel, except: [max: 2, min: 2]

  @typedoc ~S"""
  """
  @type t() :: %Archetype.String{
          trim: boolean,
          length: Archetype.Option.t(non_neg_integer) | nil,
          min: Archetype.Option.t(non_neg_integer) | nil,
          max: Archetype.Option.t(non_neg_integer) | nil
        }

  defstruct trim: false,
            length: nil,
            min: nil,
            max: nil

  @doc ~S"""
  Describes a new string type.
  """
  @spec new([option]) :: t()
        when option:
               {:trim, boolean()}
               | {:length, Archetype.Option.t(non_neg_integer())}
               | {:min, Archetype.Option.t(non_neg_integer())}
               | {:max, Archetype.Option.t(non_neg_integer())}

  def new(opts \\ []) do
    Enum.reduce(opts, %Archetype.String{}, fn
      {:trim, value}, type -> trim(type, value)
      {:length, {value, opts}}, type -> length(type, value, opts)
      {:length, value}, type -> length(type, value)
      {:min, {value, opts}}, type -> min(type, value, opts)
      {:min, value}, type -> min(type, value)
      {:max, {value, opts}}, type -> max(type, value, opts)
      {:max, value}, type -> max(type, value)
      {key, _}, _ -> raise(ArgumentError, "Unknown option #{inspect(key)} for Archetype.String")
    end)
  end

  @doc ~S"""
  Defines whether or not the input string should be trimmed.
  """
  @spec trim(t, boolean | nil) :: t

  def trim(%Archetype.String{} = type, value)
      when is_boolean(value)
      when is_nil(value),
      do: %{type | trim: value}

  @doc ~S"""
  Defines the expected exact length of the string.
  """
  @spec length(t, non_neg_integer | nil, keyword) :: t

  def length(type, value, opts \\ [])

  def length(%Archetype.String{} = type, nil, _), do: %{type | length: nil}

  @opts error: "must be exactly {{expected}} {{character * expected}} long"
  def length(%Archetype.String{} = type, value, opts)
      when is_integer(value) and value > -1 and is_list(opts),
      do: %{type | length: Archetype.Option.new(value, @opts, opts)}

  @doc ~S"""
  Defines the expected minimum length of the string.
  """
  @spec min(t, non_neg_integer | nil, keyword) :: t

  def min(type, value, opts \\ [])

  def min(%Archetype.String{} = type, nil, _), do: %{type | min: nil}

  def min(%Archetype.String{max: max}, value, _)
      when is_integer(value) and is_integer(max) and value > max,
      do: raise(ArgumentError, ":min cannot be greater than :max")

  @opts error: "must be at least {{expected}} {{character * expected}} long"
  def min(%Archetype.String{} = type, value, opts)
      when is_integer(value) and value > -1 and is_list(opts),
      do: %{type | min: Archetype.Option.new(value, @opts, opts)}

  @doc ~S"""
  Defines the expected maximum length of the string.
  """
  @spec max(t, non_neg_integer | nil, keyword) :: t

  def max(type, value, opts \\ [])

  def max(%Archetype.String{} = type, nil, _), do: %{type | max: nil}

  def max(%Archetype.String{min: min}, value, _)
      when is_integer(value) and is_integer(min) and value < min,
      do: raise(ArgumentError, ":max cannot be less than :min")

  @opts error: "must be at most {{expected}} {{character * expected}} long"
  def max(%Archetype.String{} = type, value, opts)
      when is_integer(value) and value > -1 and is_list(opts),
      do: %{type | max: Archetype.Option.new(value, @opts, opts)}
end

defimpl Archetype.Type, for: Archetype.String do
  import Archetype.Helpers

  @impl Archetype.Type
  def parse(%Archetype.String{} = type, value) do
    with :ok <- validate_required(value),
         :ok <- validate_type(value, :string),
         value <- trim(type, value),
         :ok <- validate_length(type, value),
         :ok <- validate_min(type, value),
         :ok <- validate_max(type, value),
         do: {:ok, value}
  end

  @impl Archetype.Type
  def to_spec(%Archetype.String{}), do: quote(do: String.t())

  #
  #   PRIVATE
  #

  defp trim(%Archetype.String{trim: true}, value), do: String.trim(value)
  defp trim(%Archetype.String{trim: false}, value), do: value

  defp validate_length(%Archetype.String{length: nil}, _), do: :ok
  defp validate_length(%Archetype.String{length: opt}, value) do
    ctx = %{
      expected: opt.value,
      actual: String.length(value)
    }

    case ctx.actual == ctx.expected do
      true -> :ok
      false -> {:error, issue(opt.error, ctx)}
    end
  end

  defp validate_min(%Archetype.String{min: nil}, _), do: :ok
  defp validate_min(%Archetype.String{min: opt}, value) do
    ctx = %{
      expected: opt.value,
      actual: String.length(value)
    }

    case ctx.actual >= ctx.expected do
      true -> :ok
      false -> {:error, issue(opt.error, ctx)}
    end
  end

  defp validate_max(%Archetype.String{max: nil}, _), do: :ok
  defp validate_max(%Archetype.String{max: opt}, value) do
    ctx = %{
      expected: opt.value,
      actual: String.length(value)
    }

    case ctx.actual <= ctx.expected do
      true -> :ok
      false -> {:error, issue(opt.error, ctx)}
    end
  end
end
