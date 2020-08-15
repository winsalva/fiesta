import { dom, library } from "@fortawesome/fontawesome-svg-core";

import {
  faExclamationCircle,
  faCheckCircle
} from "@fortawesome/free-solid-svg-icons"

export default () => {
  library.add(
    faCheckCircle,
    faExclamationCircle
  )
  dom.watch();
}
