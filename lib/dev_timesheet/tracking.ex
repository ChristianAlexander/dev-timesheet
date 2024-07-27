defmodule DevTimesheet.Tracking do
  @moduledoc """
  The Tracking context.
  """

  import Ecto.Query, warn: false
  alias DevTimesheet.Repo

  alias DevTimesheet.Tracking.Employee

  @doc """
  Returns the list of employees.

  ## Examples

      iex> list_employees()
      [%Employee{}, ...]

  """
  def list_employees do
    Repo.all(Employee)
  end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(id), do: Repo.get!(Employee, id)

  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(employee)
      %Ecto.Changeset{data: %Employee{}}

  """
  def change_employee(%Employee{} = employee, attrs \\ %{}) do
    Employee.changeset(employee, attrs)
  end

  alias DevTimesheet.Tracking.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  alias DevTimesheet.Tracking.TimesheetEntry

  @doc """
  Returns the list of timesheet_entries.

  ## Examples

      iex> list_timesheet_entries()
      [%TimesheetEntry{}, ...]

  """
  def list_timesheet_entries(options \\ %{}) do
    TimesheetEntry
    |> timesheet_entries_with_associations(options)
    |> timesheet_entries_with_pagination(options)
    |> timesheet_entries_with_limit(options)
    |> Repo.all()
  end

  def count_timesheet_entries() do
    TimesheetEntry
    |> Repo.aggregate(:count, :id)
  end

  defp timesheet_entries_with_associations(query, %{associations: associations})
       when is_list(associations) do
    Enum.reduce(associations, query, fn
      :employee, query ->
        preload(query, :employee)

      :project, query ->
        preload(query, :project)

      _, query ->
        query
    end)
  end

  defp timesheet_entries_with_associations(query, _), do: query

  defp timesheet_entries_with_pagination(query, %{cursor: cursor})
       when is_binary(cursor) or is_integer(cursor) do
    from([te] in query,
      where: te.id > ^cursor,
      order_by: [asc: te.id]
    )
  end

  defp timesheet_entries_with_pagination(query, _), do: query

  defp timesheet_entries_with_limit(query, %{limit: limit}) do
    from([te] in query,
      limit: ^limit
    )
  end

  defp timesheet_entries_with_limit(query, _), do: query

  @doc """
  Gets a single timesheet_entry.

  Raises `Ecto.NoResultsError` if the Timesheet entry does not exist.

  ## Examples

      iex> get_timesheet_entry!(123)
      %TimesheetEntry{}

      iex> get_timesheet_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timesheet_entry!(id), do: Repo.get!(TimesheetEntry, id)

  @doc """
  Creates a timesheet_entry.

  ## Examples

      iex> create_timesheet_entry(%{field: value})
      {:ok, %TimesheetEntry{}}

      iex> create_timesheet_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timesheet_entry(attrs \\ %{}) do
    %TimesheetEntry{}
    |> TimesheetEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timesheet_entry.

  ## Examples

      iex> update_timesheet_entry(timesheet_entry, %{field: new_value})
      {:ok, %TimesheetEntry{}}

      iex> update_timesheet_entry(timesheet_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timesheet_entry(%TimesheetEntry{} = timesheet_entry, attrs) do
    timesheet_entry
    |> TimesheetEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a timesheet_entry.

  ## Examples

      iex> delete_timesheet_entry(timesheet_entry)
      {:ok, %TimesheetEntry{}}

      iex> delete_timesheet_entry(timesheet_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timesheet_entry(%TimesheetEntry{} = timesheet_entry) do
    Repo.delete(timesheet_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timesheet_entry changes.

  ## Examples

      iex> change_timesheet_entry(timesheet_entry)
      %Ecto.Changeset{data: %TimesheetEntry{}}

  """
  def change_timesheet_entry(%TimesheetEntry{} = timesheet_entry, attrs \\ %{}) do
    TimesheetEntry.changeset(timesheet_entry, attrs)
  end
end
