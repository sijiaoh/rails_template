import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    window.Prism.highlightAllUnder(this.element);
  }
}