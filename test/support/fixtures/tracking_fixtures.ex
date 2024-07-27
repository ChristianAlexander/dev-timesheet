defmodule DevTimesheet.TrackingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DevTimesheet.Tracking` context.
  """

  @doc """
  Generate a employee.
  """
  def employee_fixture(attrs \\ %{}) do
    {:ok, employee} =
      attrs
      |> Enum.into(%{
        department: "some department",
        name: "some name",
        position: "some position"
      })
      |> DevTimesheet.Tracking.create_employee()

    employee
  end

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_date: ~D[2024-07-20],
        name: "some name",
        start_date: ~D[2024-07-20]
      })
      |> DevTimesheet.Tracking.create_project()

    project
  end

  @doc """
  Generate a timesheet_entry.
  """
  def timesheet_entry_fixture(attrs \\ %{}) do
    {:ok, timesheet_entry} =
      attrs
      |> Enum.into(%{
        check_in: ~T[14:00:00],
        check_out: ~T[14:00:00],
        date: ~D[2024-07-20],
        hours_worked: 120.5
      })
      |> DevTimesheet.Tracking.create_timesheet_entry()

    timesheet_entry
  end
end
