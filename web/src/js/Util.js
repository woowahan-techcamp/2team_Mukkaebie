import {Graph} from "./Graph.js";


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
  makeAfterLoginModal(){
    let modal = document.querySelector('#afterLoginModal');
    modal.style.display = "block";
    setTimeout(function () {
      modal.style.opacity = 1;
    }, 500)
    setTimeout(function () {
      modal.style.opacity = 0;
      setTimeout(function () {
        modal.style.display = "none";
      }, 500)
    }, 1500)
  },

  makeLoginRequiredModal(){
    let modal = document.querySelector('#loginRequiredModal');
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

  makeThxModal(){
    let modal = document.querySelector('#thxModal');
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
      if (session != "비회원") {
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


        let i = window.pageYOffset, j = 1;
        let int = setInterval(function () {
          window.scrollTo(0, i);
          i -= 5 * j;
          j += 0.2;
          if (i < 200) clearInterval(int);
        }, 20);

        xhr1.onloadend = function () {
          StoreUtil.makeModal();
          let graph = new Graph(storeId);
          StoreUtil.resetCart();
        }.bind(this);
      } else {
        StoreUtil.makeLoginRequiredModal();
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
    for (let key in attrs) {
      el.setAttribute(key, attrs[key]);
    }
  },

  ajaxGet(url, cb){
    const xhr = new XMLHttpRequest();
    xhr.addEventListener("load", cb);
    xhr.open("GET", url);
    xhr.send();
  },

  ajaxPost(url, data){
    const xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(data);
  },

  ajaxPostWithCb(url, data, cb){
    const xhr = new XMLHttpRequest();
    xhr.addEventListener("load", cb);
    xhr.open("POST", url);
    xhr.send(data);
  },

  preventXss(textInput) {
    textInput = textInput.replace(/\</g, "&lt;");
    textInput = textInput.replace(/\>/g, "&gt;");
    return textInput
  },

  makeFoldableMenu (levelOneClass){
    let levelOne = document.getElementsByClassName(levelOneClass);
    for (let i = 0; i < levelOne.length; i++) {
      levelOne[i].addEventListener("click", function () {
        this.classList.toggle("active");

        let levelTwo = this.nextElementSibling;
        if (levelTwo) {
          if (levelTwo.style.maxHeight === "1500px") {
            levelTwo.style.maxHeight = "0px";
          } else {
            levelTwo.style.maxHeight = "1500px";
          }
        }
      })
    }
  },

  toggleEdit(){
    const editBox = document.querySelector(".logInRequired");
    const editBtn = document.querySelector(".mkbEdit");
    if (editBox.classList.contains("mkbShow")) {
      editBox.classList.remove("mkbShow");
      editBtn.classList.remove("mkbHide");
      editBtn.innerText = "수정"
    } else {
      editBox.classList.add("mkbShow");
      editBtn.classList.add("mkbHide");
      editBtn.innerText = "접기"
    }
  },

  changeOpacity(targetDom, value){
    const targetDomNode = document.querySelector(targetDom);
    targetDomNode.style.opacity = value;
  },

  changeDisplay(targetDom, value){
    const targetDomNode = document.querySelector(targetDom);
    targetDomNode.style.display = value;
  },

  showModal(modal){
    const targetDomNode = document.querySelector(modal);
    targetDomNode.style.display = "block";
    setTimeout(function () {
      targetDomNode.style.opacity = "1";
    }, 200)
  },

  hideModal(modal){
    const targetDomNode = document.querySelector(modal);
    targetDomNode.style.opacity = "0";
    setTimeout(function () {
      targetDomNode.style.display = "none";
    }, 200)
  },
};


export default StoreUtil;