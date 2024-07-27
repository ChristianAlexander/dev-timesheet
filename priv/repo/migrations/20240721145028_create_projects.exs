defmodule DevTimesheet.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :description, :string
      add :start_date, :date
      add :end_date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
