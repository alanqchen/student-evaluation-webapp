import { Controller } from "stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["wrapper", "body"]

  connect() {
    enter(this.wrapperTarget)
    enter(this.bodyTarget)

    document.addEventListener('turbo:submit-end', this.handleSubmit)
  }

  disconnect() {
    document.removeEventListener('turbo:submit-end', this.handleSubmit)
  }

  close() {
    leave(this.wrapperTarget)
    leave(this.bodyTarget).then(() => {
      // Remove the modal element after the fade out so it doesn't blanket the screen
      this.element.remove()
    })

    // Remove src reference from parent frame element
    // Without this, turbo won't re-open the modal on subsequent clicks
    this.element.closest("turbo-frame").src = undefined
  }

  handleKeyup(e) {
    if (e.code == "Escape") {
      this.close()
    }
  }

  handleSubmit = (e) => {
    if (e.detail.success) {
      this.close()
    }
  }
}
