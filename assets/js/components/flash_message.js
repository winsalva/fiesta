window.flashMessageState = () => ({
  getIconClass(type) {
    let className;
    switch (type) {
      case "warning":
        className = "fas fa-exclamation-circle text-warning";
        break;
      case "error":
        className = "fas fa-exclamation-circle";
        break;
      case "success":
        className = "fas fa-check-circle text-success";
        break;
      default:
        className = "fas fa-check-circle text-info";
    }
    return className;
  },
  render({ id, type, message, title }) {
    return `
    <div class="alert alert-${type} shadow-lg flex items-center w-full md:w-138 py-4 px-6 mb-5 justify-between" x-data x-init="setTimeout(() => {$dispatch('remove-flash', {id: ${id}})}, 4000)">
      <i class="${this.getIconClass(type)} text-2xl mr-4"></i>
      <div class="flex flex-wrap leading-6 text-base -mx-1 md:w-108">
        <div class="font-semibold px-1">${title}</div>
        <div class="font-normal px-1">${message}</div>
      </div>
      <div class="cursor-pointer text-base ml-4" @click="$dispatch('remove-flash', {id: ${id}})">&times;</div>
    </div>
    `;
  },
  flashMessageId: 0,
  flashMessages: [],
  showFlashMessages: false,
  removeFlashMessage(id) {
    this.flashMessages = this.flashMessages.filter(
      (flashMessage) => flashMessage.id !== id
    );
    if (this.flashMessages.length === 0) {
      this.showFlashMessages = false;
    }
  },
  addFlashMessage(type, message, title) {
    if (type !== "" && message !== "") {
      const setTitle = title ? title : "";
      const id = this.flashMessageId;
      this.flashMessages.unshift({
        id: id,
        type: type,
        message: message,
        title: setTitle,
      });
      this.showFlashMessages = true;
      this.flashMessageId++;

      if (this.flashMessages.length > 6) {
        this.flashMessages.pop();
      }
    }
  },
});