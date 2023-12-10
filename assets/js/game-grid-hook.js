export default {
    mounted() {
        this.grid = this.el.querySelector("._grid")
        this.myTurn = this.el.dataset.myTurn == "true"
        const cells = this.el.querySelectorAll("._cell")
        for (const cell of cells) {
            cell.addEventListener("mouseenter", this.mouseHover.bind(this))
            cell.addEventListener("click", this.clicked.bind(this))
            this.grid.addEventListener("mouseleave", this.mouseLeave.bind(this))
        }
    },
    updated() {
        this.myTurn = this.el.dataset.myTurn == "true"
    },
    clearHovers() {
        document.body.querySelectorAll("._hover").forEach(el => el.remove())
    },
    clicked(e) {
        if (!this.myTurn) {
            return
        }
        this.clearHovers()
        this.myTurn = false
        if (!e.target.dataset.x || !e.target.dataset.y) {
            debugger
        }
        this.pushEvent("clicked", {x: e.target.dataset.x, y: e.target.dataset.y})
    },
    mouseHover(e) {
        // create a div for the hover effect, make it a lower index than the cells
        if (!this.myTurn) {
            return
        }
        this.clearHovers()
        const targetBounds = e.target.getBoundingClientRect()
        const gridBounds = this.grid.getBoundingClientRect()
        console.log(gridBounds)
        const hoverEl = document.createElement("div")
        hoverEl.classList.add("bg-teal-300/30")
        hoverEl.classList.add("absolute")
        hoverEl.classList.add("_hover")
        hoverEl.style.zIndex = 1
        hoverEl.style.top = gridBounds.top + "px"
        hoverEl.style.left = targetBounds.left - 5 + "px"
        hoverEl.style.height = gridBounds.height + "px"
        hoverEl.style.width = targetBounds.width + 10 + "px"
        this.grid.append(hoverEl)
    },
    mouseLeave(e) {
        console.log("Leaving")
        this.clearHovers()
    },
    highlightColumn() {

    },
}
