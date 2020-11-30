import { moveCursorToEnd } from "./helpers"
import Inputmask from "inputmask";

let Hooks = {}

Hooks.FocusInput = {
  mounted() {
    this.handleEvent("focus", () => {
      const input = this.el.querySelectorAll("input[type='text']")[0];
      input.focus();
      moveCursorToEnd(input);
    })
  }
}

Hooks.HandleModal = {
  mounted() {
    const button = document.querySelector('button[phx-click="open_modal"]');

    button.addEventListener('click', () => {
      const body = document.querySelector('body');
      body.classList.toggle('overflow-hidden');
    });
  }
}

Hooks.MaskPrice = {
  mounted() {
    let selector = this.el.querySelectorAll("[name*='price']");
    Inputmask({ alias: "currency", placeholder: "0.00" }).mask(selector);
  }
}

Hooks.HideFormOnSubmit = {
  mounted() {
    this.handleEvent("hide_form", ({ form: form }) => {
      let event = new CustomEvent("close-form", { detail: { form: form } });
      this.el.dispatchEvent(event);
    });
  }
}

export default Hooks;