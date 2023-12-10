export default {
    mounted() {
        this.el.addEventListener("click", this.clicked.bind(this))
    },
    clicked() {
        const copyId = this.el.dataset.copyId
        const copyEl = document.getElementById(copyId)
        copyEl.select()
        document.execCommand("copy")
        this.el.innerText = "Copied!"
        setTimeout(() => {
            this.el.innerText = "Copy"
        }, 3000)
    }
}
