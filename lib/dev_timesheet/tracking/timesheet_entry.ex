defmodule DevTimesheet.Tracking.TimesheetEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timesheet_entries" do
    field :date, :date
    field :check_in, :time
    field :check_out, :time
    field :hours_worked, :float
    belongs_to :employee, DevTimesheet.Tracking.Employee
    belongs_to :project, DevTimesheet.Tracking.Project

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(timesheet_entry, attrs) do
    timesheet_entry
    |> cast(attrs, [:date, :check_in, :check_out, :hours_worked, :employee_id, :project_id])
    |> validate_required([:date, :check_in, :check_out, :hours_worked, :employee_id, :project_id])
  end
end
