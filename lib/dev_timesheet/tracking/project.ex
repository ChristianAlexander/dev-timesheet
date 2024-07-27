defmodule DevTimesheet.Tracking.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string
    field :start_date, :date
    field :end_date, :date
    has_many :timesheet_entries, DevTimesheet.Tracking.TimesheetEntry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :start_date, :end_date])
    |> validate_required([:name, :description, :start_date, :end_date])
  end
end
