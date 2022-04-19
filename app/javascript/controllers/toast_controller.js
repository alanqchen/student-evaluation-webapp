import { Controller } from "stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["wrapper"]

  connect() {
    enter(this.wrapperTarget)
    setTimeout(() => this.close(), 8000)
  }

  close() {
    leave(this.wrapperTarget).then(() => {
      // Remove the modal element after the fade out so it doesn't blanket the screen
      this.element.remove()
    })

    // Remove src reference from parent frame element
    // Without this, turbo won't re-open the modal on subsequent clicks
    this.element.closest("turbo-frame").src = undefined
  }
}
