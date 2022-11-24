import animalsObject from '/static/animals.js';

window.onload = function () {
    let animalSel = document.getElementById("animal");
    let breedSel = document.getElementById("breed");
    for (let x in animalsObject) {
        animalSel.options[animalSel.options.length] = new Option(x, x);
    }
    animalSel.onchange = function () {
        //empty Breeds dropdown
        breedSel.length = 1;
        //display correct values
        for (let y in animalsObject[this.value]) {
            breedSel.options[breedSel.options.length] = new Option(y, y);
        }
    }
}
