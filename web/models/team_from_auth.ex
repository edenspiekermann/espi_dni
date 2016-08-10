defmodule EspiDni.TeamFromAuth do

  @moduledoc """
  Create or retreive the team from an auth request
  """
  import Ecto.Query
  alias Ueberauth.Auth
  alias EspiDni.Repo
  alias EspiDni.Team


  def find_or_create(%Auth{} = auth) do
    auth
    |> team_params
    |> create_or_update
  end

  defp team_params(auth) do
    %{
      slack_id: auth.credentials.other.team_id,
      token:    bot_token(auth),
      name:     auth.credentials.other.team,
      url:      auth.credentials.other.team_url
    }
  end

  defp create_or_update(%{slack_id: slack_id} = params) do
    case team_by_slack_id(slack_id) do
      nil ->
        Team.changeset(%Team{}, params)
        |> Repo.insert
      existing_team ->
        Team.changeset(existing_team, params)
        |> Repo.update
    end
  end

  defp team_by_slack_id(slack_id) do
    Repo.one(from t in Team, where: t.slack_id == ^slack_id)
  end

  defp bot_token(auth) do
    auth.extra.raw_info.token.other_params["bot"]["bot_access_token"]
  end

end