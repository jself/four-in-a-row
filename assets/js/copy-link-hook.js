export default {
    mounted() {
        this.el.addEventListener("click", this.clicked.bind(this))
    },
    clicked() {
        const copyId = this.el.dataset.copyId
        const copyEl = document.getElementById(copyId)
        copyEl.select()
        copyEl.setSelectionRange(0, 99999); // For mobile devices
        navigator.clipboard.writeText(copyEl.value);

        this.el.innerText = "Copied!"
        setTimeout(() => {
            this.el.innerText = "Copy"
        }, 3000)
    }
}
