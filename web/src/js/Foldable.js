




export class Foldable {
  constructor(level1Class) {
    this.level1 = document.getElementsByClassName(level1Class);
    this.makeFoldable();
  }

  makeFoldable() {
    for (let i = 0; i < this.level1.length; i++) {
      this.level1[i].onclick = function () {
        /* Toggle between adding and removing the "active" class,
         to highlight the button that controls the panel */
        this.classList.toggle("active");

        /* Toggle between hiding and showing the active panel */
        let level2 = this.nextElementSibling;
        if (level2) {
          if (level2.style.maxHeight === "1500px") {
            level2.style.maxHeight = "0px";
          } else {
            level2.style.maxHeight = "1500px";
          }
        }
      }
    }
  }
}