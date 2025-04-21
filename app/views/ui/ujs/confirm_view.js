import startUJS from "@rubygems/proscenium-ui/lib/proscenium/ui/ujs";
import CustomElement from "../../lib/custom_element";
startUJS();

class UjsConfirm extends CustomElement {
  static delegatedEvents = ["submit"];

  handleEvent(event) {
    event.preventDefault();
  }
}
UjsConfirm.register();
