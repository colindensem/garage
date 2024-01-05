defmodule DgWeb.VehiclesLive do
  use DgWeb, :live_view
  import Phoenix.HTML.Form
  alias Dg.Garages.Vehicle

  def render(assigns) do
    ~H"""
    <h2>Vehicles</h2>
    <div>
      <%= for vehicle <- @vehicles do %>
        <div>
          <div><%= vehicle.registration %></div>
          <div><%= if Map.get(vehicle, :nickname), do: vehicle.nickname, else: "" %></div>
          <button phx-click="delete_vehicle" phx-value-vehicle-id={vehicle.id}>delete</button>
        </div>
      <% end %>
    </div>
    <h2>Create Vehicle</h2>
    <.form :let={f} for={@create_form} phx-submit="create_vehicle">
      <%= text_input(f, :registration, placeholder: "input registration") %>
      <%= submit("create") %>
    </.form>
    <h2>Update Vehicle</h2>
    <.form :let={f} for={@update_form} phx-submit="update_vehicle">
      <%= label(f, :"vehicle name") %>
      <%= select(f, :vehicle_id, @vehicle_selector) %>
      <%= text_input(f, :nickname, value: "", placeholder: "input nickname") %>
      <%= submit("update") %>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    vehicles = Vehicle.read_all!()

    socket =
      assign(socket,
        vehicles: vehicles,
        vehicle_selector: vehicle_selector(vehicles),
        # the `to_form/1` calls below are for liveview 0.18.12+. For earlier versions, remove those calls
        create_form: AshPhoenix.Form.for_create(Vehicle, :create) |> to_form(),
        update_form:
          AshPhoenix.Form.for_update(List.first(vehicles, %Vehicle{}), :update) |> to_form()
      )

    {:ok, socket}
  end

  def handle_event("delete_vehicle", %{"vehicle-id" => vehicle_id}, socket) do
    vehicle_id |> Vehicle.get_by_id!() |> Vehicle.destroy!()
    vehicles = Vehicle.read_all!()

    {:noreply, assign(socket, vehicles: vehicles, vehicle_selector: vehicle_selector(vehicles))}
  end

  def handle_event("create_vehicle", %{"form" => %{"registration" => registration}}, socket) do
    Vehicle.create(%{registration: registration})
    vehicles = Vehicle.read_all!()

    {:noreply, assign(socket, vehicles: vehicles, vehicle_selector: vehicle_selector(vehicles))}
  end

  def handle_event("update_vehicle", %{"form" => form_params}, socket) do
    %{"vehicle_id" => vehicle_id, "nickname" => nickname} = form_params

    vehicle_id |> Vehicle.get_by_id!() |> Vehicle.update!(%{nickname: nickname})
    vehicles = Vehicle.read_all!()

    {:noreply, assign(socket, vehicles: vehicles, vehicle_selector: vehicle_selector(vehicles))}
  end

  defp vehicle_selector(vehicles) do
    for vehicle <- vehicles do
      {vehicle.registration, vehicle.id}
    end
  end
end
