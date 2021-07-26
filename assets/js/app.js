import "phoenix_html"
import "bootstrap"
import "bootstrap4-notify"
import $ from "jquery"
import css from "../css/app.scss"
import "../../deps/phoenix_html"
import "@fortawesome/fontawesome-free/js/all"
import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"
import Hooks from "./_hooks"
import "alpinejs"
import "./components/flash_message"
import runFontAwesome from "./fontawesome"
import * as UpChunk from "@mux/upchunk"

window.jQuery = $
window.$ = $

const feather = require("feather-icons")
feather.replace()

let Uploaders = {}

Uploaders.S3 = function (entries, onViewError) {
  entries.forEach(entry => {
    let formData = new FormData()
    let { url, fields } = entry.meta
    Object.entries(fields).forEach(([key, val]) => formData.append(key, val))
    formData.append("file", entry.file)
    let xhr = new XMLHttpRequest()
    onViewError(() => xhr.abort())
    xhr.onload = () => xhr.status === 204 ? entry.progress(100) : entry.error()
    xhr.onerror = () => entry.error()
    xhr.upload.addEventListener("progress", (event) => {
      if (event.lengthComputable) {
        let percent = Math.round((event.loaded / event.total) * 100)
        if (percent < 100) { entry.progress(percent) }
      }
    })

    xhr.open("POST", url, true)
    xhr.setRequestHeader("Cache-Control", "no-cache, no-store, max-age=0")
    xhr.send(formData)
  })
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  uploaders: Uploaders,
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) { window.Alpine.clone(from.__x, to) }
    }
  },
});
liveSocket.connect()

runFontAwesome();
