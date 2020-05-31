const Hooks = {
  HandleModal: {}
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

export default Hooks