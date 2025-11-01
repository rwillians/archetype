defprotocol Archetype.Type do
  @moduledoc ~S"""
  This is the protocol that must be implemented by all supported types.
  """

  @doc ~S"""
  Parses the given value according to the type definition.
  """
  @spec parse(t, term) ::
          {:ok, term}
          | {:error, [Archetype.Issue.t(), ...]}

  def parse(type, value)

  @doc ~S"""
  Derives the type specification AST from a given type.
  """
  @spec to_spec(t) :: Macro.t()

  def to_spec(type)
end
