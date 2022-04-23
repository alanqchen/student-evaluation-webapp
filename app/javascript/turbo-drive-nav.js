/* Regexs for navigation url replacement (due to turbo advance not working for
 * cases where redirect is needed)
 * 1. For project or team deletion, change url to the course url
 * 2. For course deletion, change url to the courses url
 * 3. Going to course page from project/team page
 */
let regexps = [/(\S*\d+)\/((project)|(team))\/\d+\/delete/gi, /(\S*\/courses)\/\d+\/delete/gi, /(\S*\/course\/\d+)$/gi]
document.addEventListener('turbo:click', async e => {
  for (const r of regexps) {
    let match = r.exec(e.detail.url);
    if (match) {
      history.replaceState(history.state, '', match[1]);
      break;
    }
  }
})
window.addEventListener('popstate', () => Turbo.visit(document.location))
