defmodule DevTimesheet.Repo do
  use Ecto.Repo,
    otp_app: :dev_timesheet,
    adapter: Ecto.Adapters.Postgres
end
