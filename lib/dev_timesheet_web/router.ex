defmodule DevTimesheetWeb.Router do
  use DevTimesheetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DevTimesheetWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DevTimesheetWeb do
    pipe_through :browser

    get "/", TimesheetController, :index
    get "/timesheets/export", TimesheetController, :export
    get "/timesheets/export-stream", TimesheetController, :export_stream
  end

  scope "/api", DevTimesheetWeb do
    pipe_through :api

    get "/timesheets", TimesheetController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", DevTimesheetWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dev_timesheet, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DevTimesheetWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
