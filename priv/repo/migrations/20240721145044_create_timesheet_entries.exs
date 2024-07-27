defmodule DevTimesheet.Repo.Migrations.CreateTimesheetEntries do
  use Ecto.Migration

  def change do
    create table(:timesheet_entries) do
      add :date, :date
      add :check_in, :time
      add :check_out, :time
      add :hours_worked, :float
      add :employee_id, references(:employees, on_delete: :nothing)
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:timesheet_entries, [:employee_id])
    create index(:timesheet_entries, [:project_id])
  end
end
