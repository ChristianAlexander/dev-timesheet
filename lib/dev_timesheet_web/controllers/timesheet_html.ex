defmodule DevTimesheetWeb.TimesheetHTML do
  use DevTimesheetWeb, :html

  alias DevTimesheet.Tracking

  defp display_employee(%{employee: %Ecto.Association.NotLoaded{}, employee_id: employee_id}) do
    employee_id
  end

  defp display_employee(%{employee: %Tracking.Employee{} = employee}) do
    employee.name
  end

  defp display_project(%{project: %Ecto.Association.NotLoaded{}, project_id: project_id}) do
    project_id
  end

  defp display_project(%{project: %Tracking.Project{} = project}) do
    project.name
  end

  embed_templates "timesheet_html/*"
end
