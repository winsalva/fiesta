import { dom, library } from "@fortawesome/fontawesome-svg-core";

import {
  faExclamationCircle,
  faCheckCircle,
  faChartLine,
  faBars,
  faSignOutAlt,
  faSlidersH,
} from "@fortawesome/free-solid-svg-icons"

export default () => {
  library.add(
    faCheckCircle,
    faExclamationCircle,
    faChartLine,
    faBars,
    faSignOutAlt,
    faSlidersH
  )
  dom.watch();
}
