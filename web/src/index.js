import {
  TabUiWithAjax,
  Foldable,
  Review,
  scrollWithCart,
  makeOrder,
  toggleMobileCategory,
  Graph,
  StoreList,
  StoreInfo,
  StoreUtil
} from './store.js'


import style from './scss/main.scss';


document.addEventListener("DOMContentLoaded", function () {

  console.log("loaded!");


  // let review = new Review();
  //
  //
  // let tab = new TabUiWithAjax(
  //     {
  //       containerName: "storeTabWrapper",
  //       selectedTabName: "selectedTab",
  //       selectedContentName: "selectedContent",
  //       generalTabName: "storeTab",
  //       generalContentPrefix: "#cont-",
  //       baseUrl: "",
  //     }
  // );

  // let foldable = new Foldable("foldableLevel1");
  //
  // let graph = new Graph();

  // StoreUtil.scrollWithCart();
  //
  // StoreUtil.makeOrder.call(graph);

  // document.querySelector('#mkbTab').addEventListener('click', function () {
  //   let graph = new Graph();
  //   graph.podiumAnimate();
  // });
  //
  // document.querySelector(".mobileTitleButton").addEventListener("click", function () {
  //   StoreUtil.toggleMobileCategory();
  // })

  let clickedStore = document.querySelector("#storeListTemplate");

  clickedStore.addEventListener("click", function (e) {
    if (e.target.className !== "storeCard") {
      e.target = e.target.closest(".storeCard");
    }
    let storeInfo = new StoreInfo(e.target.parentNode.value);
  });


  let clickedMenu = document.querySelector(".categoryWrapper");

  console.log(clickedMenu);

  clickedMenu.addEventListener("click", function (e) {
    if (e.target.tagName !== "LI") {
      console.log(e.target);
      e.target = e.target.closest(".blackMenu");
      console.log(e.target);
    }
    let categoryList = new StoreList(e.target.attributes.data.value);
  });


  let clickedMobileMenu = document.querySelector(".mobileCategory");

  clickedMobileMenu.addEventListener("click", function (e) {
    if (e.target.className !== "col-xs-4 mobileMenu") {
      e.target = e.target.closest(".mobilekMenu");
    }
    let categoryList = new StoreList(e.target.attributes.data.value);
  });

  let layoutTarget = document.querySelector('.storeLayout');

  layoutTarget.addEventListener("click", function () {

    if (layoutTarget.children.item(2)) {

      let tab = new TabUiWithAjax(
          {
            containerName: "storeTabWrapper",
            selectedTabName: "selectedTab",
            selectedContentName: "selectedContent",
            generalTabName: "storeTab",
            generalContentPrefix: "#cont-",
            baseUrl: "",
          }
      );

      let foldable = new Foldable("foldableLevel1");
    }
  });

});


