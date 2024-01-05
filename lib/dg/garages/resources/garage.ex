defmodule Dg.Garages.Garage do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  multitenancy do
    strategy :attribute
    attribute :user_id
  end

  code_interface do
    define_for Dg.Garages
    define :create, action: :create_garage
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    create :create_garage do
      accept [:name]
      argument :user_id, :uuid, allow_nil?: false
      change set_attribute(:slug, "test-garage-3")

      change set_tenant(arg(:user_id))
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :slug, :string, allow_nil?: false
    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, Dg.Accounts.User,
      attribute_writable?: true,
      attribute_type: :uuid,
      allow_nil?: false
  end

  postgres do
    table "garages"

    repo Dg.Repo
  end
end
