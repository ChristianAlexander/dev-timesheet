defmodule DevTimesheet.TrackingTest do
  use DevTimesheet.DataCase

  alias DevTimesheet.Tracking

  describe "employees" do
    alias DevTimesheet.Tracking.Employee

    import DevTimesheet.TrackingFixtures

    @invalid_attrs %{name: nil, position: nil, department: nil}

    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
      assert Tracking.list_employees() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert Tracking.get_employee!(employee.id) == employee
    end

    test "create_employee/1 with valid data creates a employee" do
      valid_attrs = %{name: "some name", position: "some position", department: "some department"}

      assert {:ok, %Employee{} = employee} = Tracking.create_employee(valid_attrs)
      assert employee.name == "some name"
      assert employee.position == "some position"
      assert employee.department == "some department"
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      update_attrs = %{name: "some updated name", position: "some updated position", department: "some updated department"}

      assert {:ok, %Employee{} = employee} = Tracking.update_employee(employee, update_attrs)
      assert employee.name == "some updated name"
      assert employee.position == "some updated position"
      assert employee.department == "some updated department"
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracking.update_employee(employee, @invalid_attrs)
      assert employee == Tracking.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Tracking.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Tracking.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Tracking.change_employee(employee)
    end
  end

  describe "projects" do
    alias DevTimesheet.Tracking.Project

    import DevTimesheet.TrackingFixtures

    @invalid_attrs %{name: nil, description: nil, start_date: nil, end_date: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Tracking.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Tracking.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{name: "some name", description: "some description", start_date: ~D[2024-07-20], end_date: ~D[2024-07-20]}

      assert {:ok, %Project{} = project} = Tracking.create_project(valid_attrs)
      assert project.name == "some name"
      assert project.description == "some description"
      assert project.start_date == ~D[2024-07-20]
      assert project.end_date == ~D[2024-07-20]
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", start_date: ~D[2024-07-21], end_date: ~D[2024-07-21]}

      assert {:ok, %Project{} = project} = Tracking.update_project(project, update_attrs)
      assert project.name == "some updated name"
      assert project.description == "some updated description"
      assert project.start_date == ~D[2024-07-21]
      assert project.end_date == ~D[2024-07-21]
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracking.update_project(project, @invalid_attrs)
      assert project == Tracking.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Tracking.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Tracking.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Tracking.change_project(project)
    end
  end

  describe "timesheet_entries" do
    alias DevTimesheet.Tracking.TimesheetEntry

    import DevTimesheet.TrackingFixtures

    @invalid_attrs %{date: nil, check_in: nil, check_out: nil, hours_worked: nil}

    test "list_timesheet_entries/0 returns all timesheet_entries" do
      timesheet_entry = timesheet_entry_fixture()
      assert Tracking.list_timesheet_entries() == [timesheet_entry]
    end

    test "get_timesheet_entry!/1 returns the timesheet_entry with given id" do
      timesheet_entry = timesheet_entry_fixture()
      assert Tracking.get_timesheet_entry!(timesheet_entry.id) == timesheet_entry
    end

    test "create_timesheet_entry/1 with valid data creates a timesheet_entry" do
      valid_attrs = %{date: ~D[2024-07-20], check_in: ~T[14:00:00], check_out: ~T[14:00:00], hours_worked: 120.5}

      assert {:ok, %TimesheetEntry{} = timesheet_entry} = Tracking.create_timesheet_entry(valid_attrs)
      assert timesheet_entry.date == ~D[2024-07-20]
      assert timesheet_entry.check_in == ~T[14:00:00]
      assert timesheet_entry.check_out == ~T[14:00:00]
      assert timesheet_entry.hours_worked == 120.5
    end

    test "create_timesheet_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_timesheet_entry(@invalid_attrs)
    end

    test "update_timesheet_entry/2 with valid data updates the timesheet_entry" do
      timesheet_entry = timesheet_entry_fixture()
      update_attrs = %{date: ~D[2024-07-21], check_in: ~T[15:01:01], check_out: ~T[15:01:01], hours_worked: 456.7}

      assert {:ok, %TimesheetEntry{} = timesheet_entry} = Tracking.update_timesheet_entry(timesheet_entry, update_attrs)
      assert timesheet_entry.date == ~D[2024-07-21]
      assert timesheet_entry.check_in == ~T[15:01:01]
      assert timesheet_entry.check_out == ~T[15:01:01]
      assert timesheet_entry.hours_worked == 456.7
    end

    test "update_timesheet_entry/2 with invalid data returns error changeset" do
      timesheet_entry = timesheet_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracking.update_timesheet_entry(timesheet_entry, @invalid_attrs)
      assert timesheet_entry == Tracking.get_timesheet_entry!(timesheet_entry.id)
    end

    test "delete_timesheet_entry/1 deletes the timesheet_entry" do
      timesheet_entry = timesheet_entry_fixture()
      assert {:ok, %TimesheetEntry{}} = Tracking.delete_timesheet_entry(timesheet_entry)
      assert_raise Ecto.NoResultsError, fn -> Tracking.get_timesheet_entry!(timesheet_entry.id) end
    end

    test "change_timesheet_entry/1 returns a timesheet_entry changeset" do
      timesheet_entry = timesheet_entry_fixture()
      assert %Ecto.Changeset{} = Tracking.change_timesheet_entry(timesheet_entry)
    end
  end
end
