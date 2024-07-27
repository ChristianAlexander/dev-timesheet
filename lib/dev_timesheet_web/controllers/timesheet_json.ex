defmodule DevTimesheetWeb.TimesheetJSON do
  use DevTimesheetWeb, :json

  alias DevTimesheet.Tracking

  def index(%{entries: entries, total_entries: total_entries, next_params: next_params}) do
    meta = %{
      total: total_entries
    }

    meta =
      if next_params, do: Map.put(meta, :next, ~p"/api/timesheets?#{next_params}"), else: meta

    %{
      data: Enum.map(entries, &format_timesheet_entry/1),
      meta: meta
    }
  end

  defp format_timesheet_entry(%Tracking.TimesheetEntry{} = entry) do
    %{
      id: entry.id,
      date: entry.date,
      check_in: entry.check_in,
      check_out: entry.check_out,
      hours_worked: entry.hours_worked,
      employee: format_employee(entry),
      project: format_project(entry)
    }
  end

  defp format_employee(%{employee: %Ecto.Association.NotLoaded{}, employee_id: employee_id}) do
    employee_id
  end

  defp format_employee(%{employee: %Tracking.Employee{} = employee}) do
    %{
      id: employee.id,
      name: employee.name
    }
  end

  defp format_project(%{project: %Ecto.Association.NotLoaded{}, project_id: project_id}) do
    project_id
  end

  defp format_project(%{project: %Tracking.Project{} = project}) do
    %{
      id: project.id,
      name: project.name,
      description: project.description
    }
  end
end
