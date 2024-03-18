import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  copy() {
    navigator.clipboard.writeText(window.location.href)
  }
}
