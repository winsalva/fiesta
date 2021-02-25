defmodule FiestaWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use FiestaWeb, :controller
      use FiestaWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: FiestaWeb

      import Plug.Conn
      import FiestaWeb.Gettext
      alias FiestaWeb.Router.Helpers, as: Routes
      import Phoenix.LiveView.Controller
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/fiesta_web/templates",
        pattern: "**/*",
        namespace: FiestaWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import FiestaWeb.ErrorHelpers
      import FiestaWeb.Gettext
      alias FiestaWeb.Router.Helpers, as: Routes
      import Phoenix.LiveView.Helpers
      import FiestaWeb.Helpers.HTML
      import Pow.Plug, only: [current_user: 1]
      alias FiestaWeb.CommonView
      import FiestaWeb.ViewHelpers
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
      import FiestaWeb.Gettext
    end
  end

  def live do
    quote do
      use Phoenix.LiveView
      alias FiestaWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
