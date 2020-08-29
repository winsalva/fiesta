defmodule KusinaWeb.KitchenLive.Index do
  use KusinaWeb, :live

  import Ecto.Changeset, only: [apply_changes: 1]

  alias Kusina.Kitchens
  alias Kusina.Kitchens.Kitchen
  alias Kusina.Repo
  alias Kusina.Users
  alias Kusina.Users.User
  alias KusinaWeb.KitchenView

  def render(%{step: step} = assigns) do
    KitchenView.render("setup_step_#{step}.html", assigns)
  end

  def render(assigns) do
    KitchenView.render("form.html", assigns)
  end

  def mount(params, %{"user_id" => user_id}, socket) do
    [id: user_id]
    |> Users.get_by()
    |> Repo.preload(:kitchen)
    |> case do
      nil ->
        unauthorize(socket)

      %User{kitchen: nil} = user ->
        socket
        |> assign(current_user: user)
        |> verify_steps(params)
        |> reply_socket()

      %User{kitchen: %Kitchen{}} ->
        # TODO: Redirect to show
        reply_socket(socket)
    end
  end

  def mount(_params, _session, socket), do: unauthorize(socket)

  def handle_params(%{"step" => step}, _uri, socket) when is_binary(step) do
    socket
    |> assign(step: String.to_integer(step))
    |> noreply_socket()
  end

  def handle_params(_, _, socket) do
    noreply_socket(socket)
  end

  def handle_event("validate", %{"kitchen" => params}, socket) do
    changeset =
      socket.assigns.changeset
      |> apply_changes()
      |> Kitchens.change_kitchen(params)

    socket
    |> assign(changeset: changeset)
    |> noreply_socket()
  end

  # Private Functions

  defp unauthorize(socket) do
    socket
    |> put_flash(:error, "You are unauthorized!")
    |> redirect(to: Routes.dashboard_path(socket, :index))
    |> reply_socket()
  end

  defp reply_socket(socket), do: {:ok, socket}
  defp noreply_socket(socket), do: {:noreply, socket}

  defp go_back_one_step(%{assigns: %{step: step}}) when not is_nil(step) and step != 1,
    do: step - 1

  defp go_back_one_step(_), do: 1

  defp is_valid_step(incoming_step, current_step) when incoming_step > current_step, do: false
  defp is_valid_step(_, _), do: true

  defp is_valid_changeset(%{assigns: %{changeset: changeset}}) when not is_nil(changeset),
    do: {:valid?, changeset, changeset.valid?}

  defp is_valid_changeset(%{assigns: %{current_user: current_user}})
       when not is_nil(current_user) do
    changeset = Kitchens.change_kitchen(nil, %{owner_id: current_user.id})
    {:valid?, changeset, true}
  end

  defp verify_steps(socket, params) do
    with %{"step" => incoming_step} when is_binary(incoming_step) <- params,
         incoming_step = String.to_integer(incoming_step),
         current_step = socket.assigns[:step] || 1,
         {:valid_step?, true} <- {:valid_step?, is_valid_step(incoming_step, current_step)},
         {:valid?, changeset, true} <- is_valid_changeset(socket) do
      assign(socket, changeset: changeset)
    else
      {:valid_step?, false} ->
        push_redirect(socket,
          to: Routes.live_path(socket, __MODULE__, %{step: go_back_one_step(socket)})
        )

      _invalid_params_or_step ->
        push_redirect(socket, to: Routes.live_path(socket, __MODULE__, %{step: 1}))
    end
  end
end
