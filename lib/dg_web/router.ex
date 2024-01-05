defmodule DgWeb.Router do
  use DgWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DgWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DgWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about
    get "/privacy", PageController, :privacy

    sign_in_route(register_path: "/register", reset_path: "/reset")
    sign_out_route AuthController
    auth_routes_for Dg.Accounts.User, to: AuthController
    reset_route []

    ash_authentication_live_session :authentication_required,
      on_mount: {DgWeb.LiveUserAuth, :live_user_required} do
      live "/dashboard/:garage_slug", DashboardLive
      live "/dashboard", DashboardLive
    end

    # TODO
    # sign_in_route(on_mount: [{Dg.LiveUserAuth, :live_no_user}])
  end

  # Other scopes may use custom stacks.
  # scope "/api", DgWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dg, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DgWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
