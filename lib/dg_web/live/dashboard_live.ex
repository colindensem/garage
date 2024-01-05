defmodule DgWeb.DashboardLive do
  use DgWeb, :live_view

  alias Dg.Garages

  def render(assigns) do
    ~H"""
    <div class="bg-white lg:min-w-0 lg:flex-1">
      <div class="pt-4 pb-4 pl-4 pr-6 border-t border-b border-gray-200 sm:pl-6 lg:pl-8 xl:border-t-0 xl:pl-6 xl:pt-6">
        <div class="flex items-center">
          <h1 class="flex-1 text-lg font-medium"><%= @garage.name %></h1>
          <div class="relative"></div>
        </div>
      </div>
      <!-- Select the garage tenant -->
      <div :if={@garages |> length > 0}>
        <%= for garage <- @garages do %>
          <div>
            <a href={~p"/dashboard/#{garage.slug}"}><%= garage.name %></a>
          </div>
        <% end %>
      </div>
      <!-- More vehicles... -->
      <div :if={@vehicles |> length > 0}>
        <ul role="list" class="border-b border-gray-200 divide-y divide-gray-200">
          <%= for vehicle <- @vehicles do %>
            <li class="relative py-5 pl-4 pr-6 hover:bg-gray-50 sm:py-6 sm:pl-6 lg:pl-8 xl:pl-6">
              <%= vehicle.registration %>
            </li>
          <% end %>
        </ul>
      </div>
      <div :if={@vehicles |> length == 0}>
        <ul role="list" class="border-b border-gray-200 divide-y divide-gray-200">
          <li class="relative py-5 pl-4 pr-6 hover:bg-gray-50 sm:py-6 sm:pl-6 lg:pl-8 xl:pl-6">
            You have no vehicles yet
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def mount(
        params,
        _session,
        %Phoenix.LiveView.Socket{assigns: %{current_user: %Dg.Accounts.User{}}} = old_socket
      ) do
    garage_slug = params["garage_slug"] || nil

    socket =
      old_socket
      |> assign_garages()
      |> assign_garage(garage_slug)
      |> assign_vehicles()

    {:ok, socket}
  end

  def mount(_, _, socket) do
    {:ok, socket}
  end

  def assign_garages(socket) do
    current_user = socket.assigns.current_user
    {:ok, garages} = Garages.Garage |> Ash.Query.set_tenant(current_user.id) |> Garages.read()
    assign(socket, :garages, garages)
  end

  def assign_garage(socket, slug) when is_binary(slug) do
    current_user = socket.assigns.current_user
    {:ok, garages} = Garages.Garage |> Ash.Query.set_tenant(current_user.id) |> Garages.read()

    garage =
      garages
      |> Enum.find(fn %{slug: s} -> s == slug end)

    assign(socket, :garage, garage)
  end

  def assign_garage(socket, _) do
    current_user = socket.assigns.current_user

    garage =
      Garages.Garage
      |> Ash.Query.set_tenant(current_user.id)
      |> Ash.Query.sort(created_at: :asc)
      |> Ash.Query.limit(1)
      |> Garages.read_one!()

    assign(socket, :garage, garage)
  end

  def assign_vehicles(socket) do
    assign(socket, :vehicles, [])
  end
end
