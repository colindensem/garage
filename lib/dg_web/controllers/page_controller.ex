defmodule DgWeb.PageController do
  use DgWeb, :controller

  def about(conn, _params) do
    render(conn, :about)
  end

  def privacy(conn, _params) do
    render(conn, :privacy)
  end

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
