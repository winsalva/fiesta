defmodule FiestaWeb.Page.ModalLive do
  @moduledoc false
  use FiestaWeb, :live

  alias Fiesta.Users
  alias Fiesta.Users.User
  alias FiestaWeb.PageView

  def render(assigns) do
    PageView.render("modal.html", assigns)
  end

  def mount(_params, _session, socket) do
    mount_params = %{
      tab: "sign_in",
      login_changeset: User.login_changeset(%User{}, %{}),
      register_changeset: User.changeset(%User{}, %{}),
      login_action: Routes.login_path(socket, :create),
      trigger_login_submit: false,
      trigger_signup_submit: false
    }

    {:ok, assign(socket, mount_params)}
  end

  def handle_event("submit_registration_form", %{"user" => params}, socket) do
    case Users.create(params) do
      {:ok, _user} ->
        {:noreply, assign(socket, trigger_signup_submit: true)}

      {:error, changeset} ->
        {:noreply, assign(socket, register_changeset: changeset)}
    end
  end

  def handle_event("submit_login_form", %{"user" => params}, socket) do
    case Users.authenticate(params) do
      nil ->
        changeset = %{User.login_changeset(%User{}, params) | action: :insert}
        {:noreply, assign(socket, login_changeset: changeset)}

      %User{} ->
        {:noreply, assign(socket, trigger_login_submit: true)}
    end
  end

  def handle_event("change_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, tab: tab)}
  end
end
