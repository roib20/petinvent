import animalsObject from '/static/animals.js';

window.onload = function () {
    let animalSelect = document.getElementById("animal");
    let speciesSelect = document.getElementById("species");
    for (let x in animalsObject) {
        animalSelect.options[animalSelect.options.length] = new Option(x, x);
    }
    animalSelect.onchange = function () {
        //empty Species dropdown
        speciesSelect.length = 1;
        //display correct values
        for (let y in animalsObject[this.value]) {
            speciesSelect.options[speciesSelect.options.length] = new Option(y, y);
        }
    }
}
