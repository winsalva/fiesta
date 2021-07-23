defmodule FiestaWeb.Component.MenuItemForm do
  @moduledoc false
  use FiestaWeb, :live_component

  alias Fiesta.Products
  alias Fiesta.Products.MenuItem
  alias FiestaWeb.Component.MenuItemSection
  alias FiestaWeb.Uploaders.SimpleS3Upload

  @doc "Menu item struct"
  prop menu_item, :struct, required: true

  @doc "Menu item changeset"
  data changeset, :struct

  @doc "Uploads"
  data uploads, :map

  def render(assigns) do
    ~F"""
    <div class="flex-grow flex flex-col space-y-2" :show={not is_nil(@menu_item)}>
      <div :if={@menu_item}>
        {f = form_for @changeset, "#",
          id: @id,
          class: "border border-gray-300 border-box grid p-7 gap-3 text-xs grid-cols-3",
          phx_submit: "upsert_menu_item",
          phx_target: @myself,
          phx_hook: "FiestaWeb.Component.MenuItemForm#MaskPrice",
          phx_change: "validate_menu_item"
        }
        <div class="flex flex-col space-y-2 col-span-3">
          {label f, :name}
          {text_input f, :name, class: "p-2"}
          {error_tag f, :name}
        </div>
        <div class="flex flex-col space-y-2 col-span-3">
          {label f, :description}
          {textarea f, :description, class: "p-2 resize-none"}
          {error_tag f, :description}
        </div>
        {hidden_input f, :id}
        {hidden_input f, :menu_category_id}
        <div class="flex flex-col space-y-2 col-span-1">
          {label f, :price}
          {price_input f, :price, class: "p-2", name: "menu_item[price][amount]"}
          {error_tag f, :price}
          {hidden_input f, :price, name: "menu_item[price][currency]", value: "PHP"}
        </div>
        <div class="flex flex-col space-y-2 col-span-1">
          {label f, :tax, "Tax %"}
          {text_input f, :tax, class: "p-2 price-input"}
          {error_tag f, :tax}
        </div>
        <div class="flex flex-col space-y-2 col-span-1">
          {label f, :visibility, "Item visibility"}
          {select f, :visibility, [:active, :inactive], class: "p-2"}
          {error_tag f, :visibility}
        </div>
        {live_file_input @uploads.menu_item}

        <progress :for={entry <- @uploads.menu_item.entries} value={entry.progress} max="100"> {entry.progress}% </progress>
        <#Raw></form></#Raw>
      </div>

      <button type="submit" class="btn btn-secondary" form={"#{@id}"} :if={@menu_item}> Submit changes </button>
    </div>
    """
  end

  def mount(socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:menu_item,
       accept: ~w(.jpg .jpeg .gif .png),
       max_entries: 1,
       external: &presign_upload/2
     )}
  end

  def update(assigns, socket) do
    socket = assign(socket, assigns)
    menu_item = socket.assigns.menu_item
    changeset = menu_item && MenuItem.changeset(menu_item)

    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("upsert_menu_item", %{"menu_item" => params}, socket) do
    case Products.upsert_menu_item(params) do
      {:ok, _menu_item} ->
        MenuItemSection.refresh()
        send(self(), {:item_selected, nil})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("validate_menu_item", _, socket) do
    {:noreply, socket}
  end

  defp presign_upload(entry, socket) do
    bucket = "menu-please-uploads"

    config = %{
      region: "ap-southeast-1",
      access_key_id: "AKIA2EFYLBIDTFBOLIV6",
      secret_access_key: "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"
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, bucket,
        key: entry.client_name,
        content_type: entry.client_type,
        max_file_size: socket.assigns.uploads.menu_item.max_file_size,
        expires_in: :timer.hours(1)
      )

    IO.inspect(fields, label: "FIELDS")

    meta = %{
      uploader: "S3",
      key: entry.client_name,
      url: "http://#{bucket}.s3.amazonaws.com",
      fields: fields
    }

    {:ok, meta, socket}
  end
end
