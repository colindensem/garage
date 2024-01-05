defmodule Dg.Garages do
  @moduledoc """
  This module is the entry point for the garage context.
  """
  use Ash.Api

  resources do
    resource Dg.Garages.Vehicle
    resource Dg.Garages.Garage
  end
end
