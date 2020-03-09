class IconPreview extends HTMLElement {
  connectedCallback() {
    const content = document
      .getElementById("template-icon-preview")
      .content.cloneNode(true);
    const size = Number(this.getAttribute("size") || 16);
    this.innerHTML = "";
    for (const img of content.querySelectorAll("img")) {
      img.width = size;
      img.height = size;
    }
    this.appendChild(content);
  }
}

customElements.define("icon-preview", IconPreview);
