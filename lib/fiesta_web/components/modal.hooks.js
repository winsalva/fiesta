const feather = require("feather-icons");

let FeatherIcons = {
  mounted() {
    feather.replace();
  },
  updated() {
    feather.replace();
  }
}

export { FeatherIcons };