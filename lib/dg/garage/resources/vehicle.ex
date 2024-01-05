defmodule Dg.Garage.Vehicle do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "vehicles"

    repo Dg.Repo
  end

  code_interface do
    define_for Dg.Garage
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :by_id do
      # This argument has one argument :id of type :uuid
      argument :id, :uuid, allow_nil?: false
      # This action returns a single record of type Dg.Garage.Vehicle
      get? true
      # Filters the :id given in argument
      filter expr(id == ^arg(:id))
    end
  end

  attributes do
    # add primary generated uuid
    uuid_primary_key :id

    attribute :registration, :string do
      allow_nil? false
    end

    attribute :nickname, :string
  end
end
