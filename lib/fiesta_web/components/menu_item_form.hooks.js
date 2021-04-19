import Inputmask from "inputmask";

let MaskPrice = {
  mounted() {
    console.log("MaskPrice mounted");
    let selector = this.el.querySelectorAll(".price-input");
    Inputmask({ alias: "currency", placeholder: "0.00" }).mask(selector);
  }
}

export { MaskPrice };