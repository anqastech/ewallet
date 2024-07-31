defmodule LocalLedgerDB.SchemaCase do
  @moduledoc """
  This module defines common behaviors shared for LocalLedgerDB schema tests.
  """
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias LocalLedgerDB.Repo

  using do
    quote do
      import LocalLedgerDB.SchemaCase
    end
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _pattern, key ->
        key_to_atom = String.to_existing_atom(key)

        opts
        |> Keyword.get(key_to_atom, key)
        |> to_string()
      end)
    end)
  end
end
