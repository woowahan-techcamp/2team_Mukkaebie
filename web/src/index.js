import {StoreList} from "./js/StoreList.js";
import {Login} from "./js/Login.js";
import StoreUtil from "./js/Util.js";

document.addEventListener("DOMContentLoaded", function () {

  const login = new Login();

  const chickenStoreList = new StoreList("치킨");


  const clickedMenu = document.querySelector(".categoryWrapper");
  clickedMenu.addEventListener("click", function (e) {
    if (e.target.tagName !== "LI") {
      e.target = e.target.closest(".blackMenu");
    }
    const categoryList = new StoreList(e.target.attributes.data.value);
  });


  const clickedMobileMenu = document.querySelector(".mobileMenuWrapAll");
  clickedMobileMenu.addEventListener("click", function (e) {
    if (e.target.className !== "col-xs-4 mobileMenu") {
      e.target = e.target.closest(".mobileMenu");
    }
    StoreUtil.toggleMobileCategory();
    const categoryList = new StoreList(e.target.attributes.data.value);
  });

  document.querySelector(".mobileTitleButton").addEventListener("click", function () {
    StoreUtil.toggleMobileCategory();
  });


  document.querySelector("#nonmemberBtn").addEventListener("click", function () {
    StoreUtil.hideModal("#loginModal");
  });

  document.querySelector(".mkbEdit").addEventListener("click", function () {
    StoreUtil.toggleEdit();
  });


});



