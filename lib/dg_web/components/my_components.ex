defmodule DgWeb.MyComponents do
  @moduledoc """
  Shared components for the DgWeb application.
  """
  use Phoenix.Component

  # alias Phoenix.LiveView.JS
  # import RedWeb.Gettext

  @doc """
  Renders a Navbar

  ## Examples

      <.navbar current_user={@current_user} />
  """
  attr :current_user, :map

  def navbar(assigns) do
    ~H"""
    <nav class="flex flex-wrap items-center justify-between px-2 text-white bg-gray-800 lg:px-8 sm:px-4">
      <a
        href="/"
        class="text-xl text-white whitespace-nowrap hover:text-grey-200 active:text-grey-400"
      >
        Digital Garage
      </a>
      <div class="flex flex-wrap items-center justify-end gap-3">
        <a href="/about" class="text-white hover:text-grey-200 active:text-grey-400">
          About
        </a>
        <%= if @current_user do %>
          <img
            src={@current_user.picture}
            alt="Profile Picture"
            style="width:48px;height:48px;border-radius:50%;"
            class="my-1"
          />
          <a
            href="/sign-out"
            class="rounded-lg bg-zinc-100 px-2 py-1 text-[0.8125rem] font-semibold leading-6 text-zinc-900 hover:bg-zinc-200/80 active:text-zinc-900/70"
          >
            Sign out
          </a>
        <% else %>
          <a
            href="/auth/user/auth0"
            class="rounded-lg bg-zinc-100 px-2 py-1 text-[0.8125rem] font-semibold leading-6 text-zinc-900 hover:bg-zinc-200/80 active:text-zinc-900/70 my-3"
          >
            Sign In
          </a>
        <% end %>
      </div>
    </nav>
    """
  end
end
