defmodule Dg.Garage do
  use Ash.Api

  resources do
    resource Dg.Garage.Vehicle
  end
end
