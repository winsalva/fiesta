import { moveCursorToEnd } from "./helpers"

let Hooks = {
  HandleModal: {},
  FocusInput: {},
}

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
      const body = document.querySelector('body')
      body.classList.toggle('overflow-hidden')
    });
  }
}

export default Hooks;