# Copyright 2018-2019 OmiseGO Pte Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule EWalletConfig.SchemaCase do
  @moduledoc """
  This module defines common behaviors shared for EWalletConfig schema tests.
  """
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox
  alias EWalletConfig.Repo

  using do
    quote do
      import EWalletConfig.SchemaCase
    end
  end

  setup do
    # Restarts `EWalletConfig.Config` so it does not hang on to a DB connection for too long.
    Supervisor.terminate_child(EWalletConfig.Supervisor, EWalletConfig.Config)
    Supervisor.restart_child(EWalletConfig.Supervisor, EWalletConfig.Config)

    Sandbox.checkout(Repo)
    Sandbox.checkout(ActivityLogger.Repo)
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
