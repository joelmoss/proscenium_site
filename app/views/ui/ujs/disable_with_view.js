import startUJS from "@rubygems/proscenium-ui/lib/proscenium/ui/ujs";
import CustomElement from "../../lib/custom_element";
startUJS();

class UjsDisableWith extends CustomElement {
  static delegatedEvents = ["submit"];

  handleEvent(event) {
    event.preventDefault();

    if (event.target.id === "my-form") {
      setTimeout(() => {
        event.submitter.resetDisableWith();
      }, 1000);
    }
  }
}
UjsDisableWith.register();
