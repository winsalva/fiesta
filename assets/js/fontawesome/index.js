import { dom, library } from "@fortawesome/fontawesome-svg-core";

import {
  faExclamationCircle,
  faCheckCircle,
  faChartLine,
  faBars,
  faSignOutAlt,
  faSlidersH,
  faStore,
  faArrowRight,
  faArrowLeft
} from "@fortawesome/free-solid-svg-icons"

export default () => {
  library.add(
    faCheckCircle,
    faExclamationCircle,
    faChartLine,
    faBars,
    faSignOutAlt,
    faSlidersH,
    faStore,
    faArrowRight,
    faArrowLeft
  )
  dom.watch();
}
