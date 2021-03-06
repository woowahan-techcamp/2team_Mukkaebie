




export class TabUiWithAjax {

  constructor(inputObj) {
    this.nav = document.querySelector("#" + inputObj.containerName);

    this.selectedTabName = inputObj.selectedTabName;
    this.selectedTab = "." + inputObj.selectedTabName;

    this.selectedContentName = inputObj.selectedContentName;
    this.selectedContent = "." + inputObj.selectedContentName;

    this.generalContentPrefix = inputObj.generalContentPrefix;

    this.init();
  }

  init() {
    this.nav.addEventListener("click", function (event) {
      this.tabOperate(event)
    }.bind(this), false);
  }

  tabOperate(event) {
    let currentTabId = "";
    const selectedTab = document.querySelector(this.selectedTab);
    selectedTab.classList.remove(this.selectedTabName);

    if (event.target && event.target.tagName === "LI") {
      event.target.classList.add(this.selectedTabName);
      currentTabId += event.target.id;
    }
    else {
      let correctedTarget = document.querySelector("#mkbTab");
      correctedTarget.classList.add(this.selectedTabName);
      currentTabId += correctedTarget.id;
    }

    const targetContentName = this.generalContentPrefix + currentTabId;
    const targetContent = document.querySelector(targetContentName);
    const selectedContent = document.querySelector(this.selectedContent);
    selectedContent.classList.remove(this.selectedContentName);
    targetContent.classList.add(this.selectedContentName);
  }


}