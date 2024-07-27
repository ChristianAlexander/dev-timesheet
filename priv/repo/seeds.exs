# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DevTimesheet.Repo.insert!(%DevTimesheet.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# priv/repo/seeds.exs
alias DevTimesheet.Repo
alias DevTimesheet.Tracking
alias DevTimesheet.Tracking.TimesheetEntry

# Insert employees
employees =
  for i <- 1..1000 do
    {:ok, employee} =
      Tracking.create_employee(%{
        name: "Employee #{i}",
        position: "Position #{i}",
        department: "Department #{i}"
      })

    employee
  end

# Insert projects
projects =
  for i <- 1..10 do
    {:ok, project} =
      Tracking.create_project(%{
        name: "Project #{i}",
        description: "Description for project #{i}",
        start_date: ~D[2024-01-01],
        end_date: ~D[2024-12-31]
      })

    project
  end

# Insert timesheet entries
timesheet_entries =
  1..100_000
  |> Stream.chunk_every(1000)
  |> Stream.map(fn items ->
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    items =
      Enum.map(items, fn id ->
        %{
          id: id,
          employee_id: Enum.random(employees).id,
          project_id: Enum.random(projects).id,
          date: ~D[2024-01-01] |> Date.add(Enum.random(0..365)),
          check_in: ~T[08:00:00],
          check_out: ~T[17:00:00],
          hours_worked: 8.0,
          inserted_at: now,
          updated_at: now
        }
      end)

    Repo.insert_all(TimesheetEntry, items)
  end)
  |> Stream.run()
