defmodule DevTimesheet.Tracking.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :name, :string
    field :position, :string
    field :department, :string
    has_many :timesheet_entries, DevTimesheet.Tracking.TimesheetEntry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :position, :department])
    |> validate_required([:name, :position, :department])
  end
end
