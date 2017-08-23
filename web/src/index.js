

import {StoreList} from './js/StoreList.js';


import style from './scss/main.scss';

document.addEventListener("DOMContentLoaded", function () {


  //첫 화면에 치킨 리스트 인젝트
  let chickenStoreList = new StoreList("치킨");
  //카테고리 클릭시 카테고리 리스트 인젝트
  let clickedMenu = document.querySelector(".categoryWrapper");
  clickedMenu.addEventListener("click", function (e) {
    if (e.target.tagName !== "LI") {
      e.target = e.target.closest(".blackMenu");
    }
    let categoryList = new StoreList(e.target.attributes.data.value);
  });


  // 모바일 뷰에서 카테고리 메뉴 토글
  document.querySelector(".mobileTitleButton").addEventListener("click", function () {
    StoreUtil.toggleMobileCategory();
  })
  // 모바일 카테고리 클릭시 카테고리 리스트 인젝트
  let clickedMobileMenu = document.querySelector(".mobileMenuWrapAll");
  clickedMobileMenu.addEventListener("click", function (e) {
    if (e.target.className !== "col-xs-4 mobileMenu") {
      e.target = e.target.closest(".mobileMenu");
    }
  StoreUtil.toggleMobileCategory();
  let categoryList = new StoreList(e.target.attributes.data.value);
  });
});






