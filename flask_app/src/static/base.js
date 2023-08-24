import prioritiesObject from '/static/priorities.js';

window.onload = function () {
    let prioritySelect = document.getElementById("priority");
    let subSelect = document.getElementById("sub");
    for (let x in prioritiesObject) {
        prioritySelect.options[prioritySelect.options.length] = new Option(x, x);
    }
    prioritySelect.onchange = function () {
        //empty sub dropdown
        subSelect.length = 1;
        //display correct values
        for (let y in prioritiesObject[this.value]) {
            subSelect.options[subSelect.options.length] = new Option(y, y);
        }
    }
}
