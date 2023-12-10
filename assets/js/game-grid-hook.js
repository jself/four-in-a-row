export default {
    mounted() {
        this.grid = this.el.querySelector("._grid")
        this.staging = this.el.querySelector("._staging")
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
        document.body.querySelectorAll("._staging-cell").forEach(el => el.remove())
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
    addStagingCell(targetBounds) {
        const stagingBounds = this.staging.getBoundingClientRect()
        const cell = document.createElement("div")
        cell.setAttribute("class", "absolute flex justify-center items-center p-2 lg:p-4 _staging-cell")
        const token = document.createElement("div")
        token.setAttribute("class", "rounded-full aspect-square bg-blue-500 w-[20px] md:w-[40px] lg:w-[48px]")
        cell.append(token)

        cell.style.zIndex = 2
        cell.style.top = stagingBounds.top + "px"
        cell.style.left = targetBounds.left + "px"
        cell.style.height = stagingBounds.height + "px"
        cell.style.width = targetBounds.width + "px"
        this.grid.append(cell)
    },
    addHoverColumn(targetBounds) {
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
    mouseHover(e) {
        // create a div for the hover effect, make it a lower index than the cells
        if (!this.myTurn) {
            return
        }
        const targetBounds = e.target.getBoundingClientRect()
        this.clearHovers()
        this.addHoverColumn(targetBounds)
        this.addStagingCell(targetBounds)
    },
    mouseLeave(e) {
        console.log("Leaving")
        this.clearHovers()
    },
    highlightColumn() {

    },
}
