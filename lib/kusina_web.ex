defmodule KusinaWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use KusinaWeb, :controller
      use KusinaWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: KusinaWeb

      import Plug.Conn
      import KusinaWeb.Gettext
      alias KusinaWeb.Router.Helpers, as: Routes
      import Phoenix.LiveView.Controller
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/kusina_web/templates",
        pattern: "**/*",
        namespace: KusinaWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import KusinaWeb.ErrorHelpers
      import KusinaWeb.Gettext
      alias KusinaWeb.Router.Helpers, as: Routes
      import Phoenix.LiveView.Helpers
      import KusinaWeb.Helpers.HTML
      import Pow.Plug, only: [current_user: 1]
      alias KusinaWeb.CommonView
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import KusinaWeb.Gettext
    end
  end

  def live do
    quote do
      use Phoenix.LiveView
      alias KusinaWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
