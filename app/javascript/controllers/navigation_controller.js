import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['content', 'loading', 'link'];

  displayLoading(event) {
    this.loadingTarget.classList.remove('hidden');
    this.contentTarget.classList.add('hidden');

    let value = event.detail.url;

    this.updateLinks(value);
    history.pushState(history.state, '', value)
  }

  displayContent() {
    this.loadingTarget.classList.add('hidden');
    this.contentTarget.classList.remove('hidden');
  }

  updateLinks(item) {
    let activeClasses = ['active', 'text-blue-600', 'border-blue-600'];

    this.linkTargets.forEach((link) => {
      link.classList.remove(...activeClasses);
      if (link.href === item) {
        link.classList.add(...activeClasses);
      }
    })
  }
}
