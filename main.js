class HTMLIconPreviewElement extends HTMLElement {
  connectedCallback() {
    const template = document
      .getElementById("template-icon-preview")
      .content.cloneNode(true);
    this.innerHTML = "";
    this.appendChild(template);
    const size = Number(this.dataset.size || 16);
    for (const img of this.querySelectorAll("img")) {
      const { iconName } = img.dataset;
      img.width = size;
      img.height = size;
      img.src = `/dist/png/${size}/${iconName}.png`;
    }
  }
}

customElements.define("icon-preview", HTMLIconPreviewElement);
