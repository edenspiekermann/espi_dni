defmodule EspiDni.UserFromAuth do

  @moduledoc """
  Create or retreive the user from an auth request
  """
  import Ecto.Query
  alias Ueberauth.Auth
  alias EspiDni.Repo
  alias EspiDni.User

  def find_or_create(%Auth{} = auth, team) do
    auth
    |> user_params
    |> Map.put(:team_id, team.id)
    |> create_or_update
  end

  defp user_params(auth) do
    %{
      slack_id: auth.credentials.other.user_id,
      username: auth.credentials.other.user,
      name:     name_from_auth(auth),
      email:    auth.extra.raw_info.user["profile"]["email"],
      timezone: auth.extra.raw_info.user["tz"]
    }
  end

  defp create_or_update(%{slack_id: slack_id} = params) do
    case user_by_slack_id(slack_id) do
      nil ->
        %User{}
        |> User.changeset(params)
        |> Repo.insert
      existing_team ->
        existing_team
        |> User.changeset(params)
        |> Repo.update
    end
  end

  defp user_by_slack_id(slack_id) do
    Repo.get_by(User, slack_id: slack_id)
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
              |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end

end
