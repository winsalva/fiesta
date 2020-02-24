import "phoenix_html"
import "bootstrap"
import "bootstrap4-notify"
import $ from "jquery"
import css from "../css/app.scss"
import "../../deps/phoenix_html"
import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

window.jQuery = $
window.$ = $

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken } });
liveSocket.connect()
