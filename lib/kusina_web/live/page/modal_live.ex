defmodule KusinaWeb.Page.ModalLive do
  use Phoenix.LiveView

  alias Kusina.Users
  alias Kusina.Users.User
  alias KusinaWeb.Endpoint
  alias KusinaWeb.PageView
  alias KusinaWeb.Router.Helpers, as: Routes

  @redirect_token_salt Application.get_env(:kusina, :redirect_token_salt)
  @redirect_token_timeout Application.get_env(:kusina, :redirect_token_timeout)

  def render(assigns) do
    PageView.render("modal.html", assigns)
  end

  def mount(_params, _session, socket) do
    mount_params = %{
      tab: "sign_in",
      login_changeset: User.login_changeset(%User{}, %{}),
      register_changeset: User.changeset(%User{}, %{})
    }

    {:ok, assign(socket, mount_params)}
  end

  def handle_event("submit_registration_form", %{"user" => params}, socket) do
    case Users.create(params) do
      {:ok, user} ->
        {:noreply,
         redirect(socket,
           to:
             Routes.session_path(
               socket,
               :callback,
               :self,
               socket.assigns.tab,
               token: generate_redirect_token(user.id)
             )
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, register_changeset: changeset)}
    end
  end

  def handle_event("submit_login_form", %{"user" => params}, socket) do
    case Users.authenticate(params) do
      nil ->
        changeset =
          %User{}
          |> User.login_changeset(params)
          |> Map.put(:action, :insert)

        {:noreply, assign(socket, login_changeset: changeset)}

      %User{id: user_id} ->
        {:noreply,
         redirect(socket,
           to:
             Routes.session_path(
               socket,
               :callback,
               :self,
               socket.assigns.tab,
               token: generate_redirect_token(user_id)
             )
         )}
    end
  end

  def handle_event("change_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, tab: tab)}
  end

  defp generate_redirect_token(user_id) do
    token_timeout = DateTime.add(DateTime.utc_now(), @redirect_token_timeout)

    Phoenix.Token.encrypt(Endpoint, @redirect_token_salt, {user_id, token_timeout})
  end
end
