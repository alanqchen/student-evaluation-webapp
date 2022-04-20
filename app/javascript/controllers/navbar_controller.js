import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Used when the navbarTop turbo frame is updated,
  // so flowbite re-adds hooks
  connect() {
    document.dispatchEvent(new Event('turbo:load'));
  }
}
