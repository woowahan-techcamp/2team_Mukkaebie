




export class Foldable {
  constructor(levelOneClass) {
    this.levelOne = document.getElementsByClassName(levelOneClass);
    this.makeFoldable();
  }

  makeFoldable() {
    for (let i = 0; i < this.levelOne.length; i++) {
      this.levelOne[i].onclick = function () {
        this.classList.toggle("active");

        let levelTwo = this.nextElementSibling;
        if (levelTwo) {
          if (levelTwo.style.maxHeight === "1500px") {
            levelTwo.style.maxHeight = "0px";
          } else {
            levelTwo.style.maxHeight = "1500px";
          }
        }
      }
    }
  }
}

