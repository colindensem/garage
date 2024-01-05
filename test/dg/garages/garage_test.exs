defmodule Dg.Garages.GarageTest do
  use Dg.DataCase, async: true
  alias Dg.Garages.Garage

  setup do
    user = Dg.Factory.user_factory()
    %{user: user}
  end

  describe "creates a new garage" do
    test "creates a new garage", %{user: user} do
      assert {:ok,
              %Garage{
                name: "Test Garage",
                slug: "test-garage"
              }} =
               Garage.create(
                 %{
                   name: "Test Garage",
                   slug: "test-garage"
                 },
                 actor: user
               )
    end
  end
end
