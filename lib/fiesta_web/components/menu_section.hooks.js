let HandleToggleCategories = {
  mounted() {
    this.handleEvent("hide_categories", ({ except_menu }) => {
      this.pushEventTo(".menu-section-item", "hide_categories", { except_menu })
    })
  }
}

export { HandleToggleCategories };