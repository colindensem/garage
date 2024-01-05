defmodule Dg.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  code_interface do
    define_for Dg.Accounts
    define :get_by_id, args: [:id], action: :by_id
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :auth0_id, :string, allow_nil?: false, private?: true
    attribute :email_verified, :boolean
    attribute :picture, :string
    attribute :name, :string
    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :garages, Dg.Garages.Garage
  end

  postgres do
    table "users"
    repo Dg.Repo
  end

  authentication do
    api Dg.Accounts

    strategies do
      auth0 do
        client_id Dg.Secrets
        redirect_uri Dg.Secrets
        client_secret Dg.Secrets
        base_url Dg.Secrets
      end
    end
  end

  identities do
    identity :unique_email, [:email]
    identity :unique_auth0_id, [:auth0_id]
  end

  actions do
    create :register_with_auth0 do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      upsert? true
      upsert_identity :unique_auth0_id

      change fn changeset, _ ->
        user_info = Ash.Changeset.get_argument(changeset, :user_info)

        changes =
          user_info
          |> Map.take([
            "email_verified",
            "email",
            "name",
            "picture"
          ])
          |> Map.put("auth0_id", Map.get(user_info, "sub"))

        Ash.Changeset.change_attributes(
          changeset,
          changes
        )
      end
    end

    # Defines custom read action which fetches post by id.
    read :by_id do
      # This action has one argument :id of type :uuid
      argument :id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(id == ^arg(:id))
    end
  end
end
