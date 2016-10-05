defmodule EspiDni.TeamControllerTest do
  use EspiDni.ConnCase

  alias EspiDni.Team
  @valid_attrs %{slack_id: "some content", slack_token: "some content", name: "teamname", url: "some content"}
  @invalid_attrs %{slack_token: "", slack_id: "", name: ""}

  setup do
    team = insert_team
    {:ok, conn: build_conn, team: team}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, team_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing teams"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, team_path(conn, :new)
    assert html_response(conn, 200) =~ "New team"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, team_path(conn, :create), team: @valid_attrs
    assert redirected_to(conn) == team_path(conn, :index)
    assert Repo.get_by(Team, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, team_path(conn, :create), team: @invalid_attrs
    assert html_response(conn, 200) =~ "New team"
  end

  test "shows chosen resource", %{conn: conn, team: team} do
    conn = get conn, team_path(conn, :show, team)
    assert html_response(conn, 200) =~ "Show team"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, team_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, team: team} do
    conn = get conn, team_path(conn, :edit, team)
    assert html_response(conn, 200) =~ "Edit team"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, team: team} do
    conn = put conn, team_path(conn, :update, team), team: @valid_attrs
    assert redirected_to(conn) == team_path(conn, :show, team)
    assert Repo.get_by(Team, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, team: team} do
    conn = put conn, team_path(conn, :update, team), team: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit team"
  end

  test "deletes chosen resource", %{conn: conn, team: team} do
    conn = delete conn, team_path(conn, :delete, team)
    assert redirected_to(conn) == team_path(conn, :index)
    refute Repo.get(Team, team.id)
  end
end
