defmodule DevTimesheetWeb.TimesheetController do
  use DevTimesheetWeb, :controller
  alias DevTimesheet.Tracking
  alias NimbleCSV.Spreadsheet, as: CSV

  @max_page_size 1000
  @supported_expands ["employee", "project"]

  def index(conn, params) do
    associations = as_associations(params["expand"])

    limit =
      with {limit, _} <- Integer.parse(params["limit"] || "", 10) do
        limit
      else
        _ -> 100
      end
      |> min(@max_page_size)
      |> max(1)

    timesheets =
      Tracking.list_timesheet_entries(%{
        associations: associations,
        # Fetch one more than the limit to check if there is a next page
        limit: limit + 1,
        cursor: params["cursor"]
      })

    total_entries = Tracking.count_timesheet_entries()
    entries = Enum.take(timesheets, limit)

    next_params =
      if length(timesheets) > limit do
        Map.merge(params, %{
          "limit" => limit,
          "cursor" => if(Enum.empty?(entries), do: nil, else: List.last(entries).id)
        })
      else
        nil
      end

    conn
    |> render(:index,
      entries: entries,
      total_entries: total_entries,
      limit: limit,
      params: params,
      next_params: next_params,
      export_url: ~p"/timesheets/export"
    )
  end

  @csv_headers [
    "ID",
    "Date",
    "Check In",
    "Check Out",
    "Hours Worked",
    "Employee ID",
    "Employee Name",
    "Project ID",
    "Project Name",
    "Project Description"
  ]

  def export(conn, _params) do
    entries =
      Tracking.list_timesheet_entries(%{
        associations: [:employee, :project]
      })

    csv_data = Enum.map(entries, &format_timesheet_entry/1)
    response_body = NimbleCSV.Spreadsheet.dump_to_iodata([@csv_headers | csv_data])

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=timesheet_entries.csv")
    |> send_resp(200, response_body)
  end

  def export_stream(conn, _params) do
    batch_size = 1000

    stream =
      Stream.resource(
        fn -> 0 end,
        fn cursor ->
          entries =
            Tracking.list_timesheet_entries(%{
              associations: [:employee, :project],
              limit: batch_size,
              cursor: cursor
            })

          if Enum.empty?(entries) do
            {:halt, entries}
          else
            {entries, List.last(entries).id}
          end
        end,
        fn _ -> :ok end
      )

    {:ok, conn} =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", "attachment; filename=timesheet_entries.csv")
      |> send_chunked(200)
      |> chunk(CSV.dump_to_iodata([@csv_headers]))

    stream
    |> Stream.map(&format_timesheet_entry/1)
    |> CSV.dump_to_stream()
    |> Enum.reduce_while(conn, fn line, conn ->
      case chunk(conn, line) do
        {:ok, conn} ->
          {:cont, conn}
        {:error, "closed"} ->
          {:halt, conn}
      end
    end)
  end

  defp format_timesheet_entry(%Tracking.TimesheetEntry{} = entry) do
    [
      entry.id,
      entry.date,
      entry.check_in,
      entry.check_out,
      entry.hours_worked,
      entry.employee_id,
      entry.employee.name,
      entry.project_id,
      entry.project.name,
      entry.project.description
    ]
  end

  defp as_associations(nil), do: []

  defp as_associations(expands) when is_binary(expands) do
    String.split(expands, ",")
    |> as_associations()
  end

  defp as_associations(expands) when is_list(expands) do
    expands
    |> Enum.filter(&(&1 in @supported_expands))
    |> Enum.map(&String.to_existing_atom/1)
  end
end
