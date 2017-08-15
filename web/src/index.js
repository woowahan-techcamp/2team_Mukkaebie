import {
  TabUiWithAjax,
  Foldable,
  Review,
  scrollWithCart,
  makeOrder,
  toggleMobileCategory,
  Graph,
  StoreUtil
} from './store.js'


import style from './scss/main.scss';




document.addEventListener("DOMContentLoaded", function(){


  let review = new Review();


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

  let graph = new Graph();

  StoreUtil.scrollWithCart();

  StoreUtil.makeOrder.call(graph);

  document.querySelector('#mkbTab').addEventListener('click', function(){
    let graph = new Graph();
    graph.podiumAnimate();
  });

  document.querySelector(".mobileTitleButton").addEventListener("click", function(){
    StoreUtil.toggleMobileCategory();
  })


});

