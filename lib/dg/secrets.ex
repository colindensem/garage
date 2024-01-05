defmodule Dg.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :strategies, :auth0, :client_id], Dg.Accounts.User, _) do
    get_config(:client_id)
  end

  def secret_for([:authentication, :strategies, :auth0, :redirect_uri], Dg.Accounts.User, _) do
    get_config(:redirect_uri)
  end

  def secret_for([:authentication, :strategies, :auth0, :client_secret], Dg.Accounts.User, _) do
    get_config(:client_secret)
  end

  def secret_for([:authentication, :strategies, :auth0, :base_url], Dg.Accounts.User, _) do
    get_config(:base_url)
  end

  defp get_config(key) do
    :dg
    |> Application.fetch_env!(:auth0)
    |> Keyword.fetch!(key)
    |> then(&{:ok, &1})
  end
end
