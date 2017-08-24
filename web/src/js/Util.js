
import {Graph} from './Graph.js'



let StoreUtil = {
  scrollWithCart: function () {
    document.addEventListener("scroll", function () {
      if (window.innerWidth > 768) {
        if (window.scrollY > 583) {
          let cart = document.querySelector(".storeCart");
          cart.style.position = "fixed";
          cart.style.top = "10px";
          cart.style.width = "200px"
        }
        else {
          let cart = document.querySelector(".storeCart");
          cart.style.position = "inherit";
          cart.style.top = "";
          cart.style.width = ""
        }
      }
      else {
        let cart = document.querySelector(".storeCart");
        cart.style.position = "inherit";
        cart.style.top = "";
        cart.style.width = ""
      }
    })
  },

  makeModal: function () {
    let modal = document.querySelector('#orderModal');
      modal.style.display = "block";
      setTimeout(function () {
        modal.style.opacity = 1;
      }, 500)
      setTimeout(function () {
        modal.style.opacity = 0;
        setTimeout(function () {
          modal.style.display = "none";
        }, 500)
      }, 3000)
  },

  makeOrder: function (storeId) {



      let orderButton = document.querySelector("#cartOrderButton");

      orderButton.addEventListener("click", function () {
        if (session != "") {
          let totalPrice = Number(document.querySelector("#cartTotalPrice").innerText);

          let cartContent = Array.from(document.querySelector(".storeCartContent").children);

          let menuList = [];

          cartContent.forEach(function (item) {
            menuList.push(item.getAttribute("value"));
          })


          let packet = {};
          packet["sellerId"] = storeId;
          packet["buyerId"] = session;
          packet["content"] = menuList;
          packet["price"] = totalPrice;

          let xhr1 = new XMLHttpRequest();
          xhr1.open("POST", SERVER_BASE_URL + "/orders", true);
          xhr1.setRequestHeader('Content-Type', 'application/json');

          // send the collected data as JSON
          xhr1.send(JSON.stringify(packet));

          xhr1.onloadend = function () {
            StoreUtil.makeModal();
            let graph = new Graph(storeId);
            StoreUtil.resetCart();
          }.bind(this);
        } else {
          alert("로그인을 해주세요")
        }
      }.bind(this));
  },

  resetCart: function () {
    let renderTarget = document.querySelector(".storeCartContent");
    let cartTotalPrice = document.querySelector("#cartTotalPrice");
    cartTotalPrice.innerText = 0;
    cartTotalPrice.value = 0;
    renderTarget.innerHTML = "";
    Array.from(document.querySelectorAll("input[type='checkbox']")).forEach(function (cb) {
      cb.checked = false
    });
    Array.from(document.querySelectorAll(".foldableLevel1.active")).forEach(function (fb) {
      fb.click()
    })
  },

  toggleMobileCategory: function () {
    let x = document.querySelector('.mobileCategory');
    let btn = document.querySelector(".mobileTitleButton");
    if (btn.classList.contains("unfolded")) {
      x.classList.remove("mobileCategoryShow");
      btn.classList.remove("unfolded");
    } else {
      x.classList.add("mobileCategoryShow");
      btn.classList.add("unfolded");
    }
  },

  setAttributes(el, attrs) {
    for(let key in attrs) {
      el.setAttribute(key, attrs[key]);
      }
  }
}




export default StoreUtil;