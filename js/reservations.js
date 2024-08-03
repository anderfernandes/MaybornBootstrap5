document.querySelector("input[type=range][name=students]").addEventListener("input", function (e) {
  document.querySelector("#students-count").textContent = e.currentTarget.value
})

document.querySelector("input[type=range][name=teachers]").addEventListener("input", function (e) {
  document.querySelector("#teachers-count").textContent = e.currentTarget.value
})

document.querySelector("input[type=range][name=parents]").addEventListener("input", function (e) {
  document.querySelector("#parents-count").textContent = e.currentTarget.value
})

if (document.querySelector("#organization")) {
  document.querySelector("#organization").onchange = function (e) {
    document.querySelector("#organization-details").style.display =
      e.currentTarget.value === "0" ? "flex" : "none"
  }
}