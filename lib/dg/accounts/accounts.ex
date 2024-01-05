defmodule Dg.Accounts do
  use Ash.Api

  resources do
    resource Dg.Accounts.User
  end
end
