




export class Cart {
  constructor() {
    this.totalPriceDisplay = document.querySelector("#cartTotalPrice");
    this.renderTarget = document.querySelector(".storeCartContent");
    this.itemsInCart = Array.from(this.renderTarget.children);
    this.init();
  }

  init() {
    document.querySelector(".foldableMenu").addEventListener("click", function (e) {
      if (e.target.tagName === "INPUT") {
        this.changeCart(e.target.value, e.target.attributes.data.value);
        this.refreshCart();
        this.calcTotal();
      }
    }.bind(this));
  }

  changeCart(cont, price) {
    let numberTypePrice = price.slice(0, price.length - 1).split(',').join('');
    let childToRemove = this.checkItemInCart(this.itemsInCart, cont, price);
    let isInCart = Boolean(childToRemove);

    if (isInCart === false) {
      let renderContent = "<li data='" + numberTypePrice + "' value='" + cont + "'>" + cont + " " + price + "</li>";
      this.addToCart(this.renderTarget, renderContent);
    }
    else {
      this.removeFromCart(this.renderTarget, childToRemove);
    }
  }

  checkItemInCart(itemsInCart, cont, price){
    let childToRemove = undefined;
    itemsInCart.forEach(function (child) {
      if (cont + " " + price === child.outerText) {
        childToRemove = child;
      }
    });
    return childToRemove;
  }


  addToCart(renderTarget, renderContent) {
    renderTarget.innerHTML += renderContent
  }

  removeFromCart(renderTarget, childToRemove){
    renderTarget.removeChild(childToRemove);
  }

  refreshCart(){
    this.itemsInCart = Array.from(this.renderTarget.children);
  }

  calcTotal() {
    let totalPrice = 0;
    this.itemsInCart.forEach(function (child) {
      totalPrice += Number(child.attributes.data.value);
    });
    this.totalPriceDisplay.innerText = totalPrice;
  }
}