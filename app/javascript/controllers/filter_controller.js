import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source", "filterable" ]
  
  filter() {
    let searchTerm = this.sourceTarget.value.toLowerCase()

    this.filterableTargets.forEach((el) => {
      let filterableKey =  el.getAttribute("data-filter-key")

      el.classList.toggle("hidden", !filterableKey.includes( searchTerm ) )
    })
  }
}
