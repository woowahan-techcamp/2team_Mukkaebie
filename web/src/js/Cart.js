




export class Cart {
  constructor() {
    this.init();
  }

  init() {
    document.querySelector(".foldableMenu").addEventListener("click", function (e) {
      if (e.target.tagName === "INPUT") {
        this.addToCart(e.target.value, e.target.attributes.data.value);
      }
    }.bind(this));
  }

  addToCart(cont, price) {
    let renderTarget = document.querySelector(".storeCartContent");
    let renderTargetChildren = Array.from(renderTarget.children);
    let numberPrice = price.slice(0, price.length - 1).split(',').join('');
    let renderContent = "<li data='" + numberPrice + "' value='" + cont + "'>" + cont + " " + price + "</li>";
    let hasContent = false;
    let childToRemove;
    renderTargetChildren.forEach(function (child) {
      if (cont + " " + price === child.outerText) {
        hasContent = true;
        childToRemove = child;
      }
    });

    if (hasContent === false) {
      renderTarget.innerHTML += renderContent;
    } else {
      renderTarget.removeChild(childToRemove);
    }
    this.calcTotal();
  }

  calcTotal() {
    let cartList = document.querySelector(".storeCartContent");
    let cartListChildren = Array.from(cartList.children);
    let totalPrice = 0;
    cartListChildren.forEach(function (child) {
      totalPrice += Number(child.attributes.data.value);
    })
    document.querySelector("#cartTotalPrice").innerText = totalPrice;
  }
}


