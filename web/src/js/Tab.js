


export class TabUi {

  constructor(inputObj) {
    this.nav = document.querySelector("#" + inputObj.containerName);
    this.selectedTabName = inputObj.selectedTabName;
    this.selectedTab = "." + inputObj.selectedTabName;
    this.selectedContentName = inputObj.selectedContentName;
    this.selectedContent = "." + inputObj.selectedContentName;
    this.generalContentPrefix = inputObj.generalContentPrefix;
    this.currentTabId = "";
    this.init();
  }

  init() {
    this.nav.addEventListener("click", function (event) {

      this.unselectCurrentTab();

      if (event.target && event.target.tagName === "LI") {
        this.clickCorrectTab(event);
      }
      else {
        this.clickTabDelegation()
      }

      this.showAndHideTabContent()

    }.bind(this));
  }


  unselectCurrentTab(){
    this.currentTabId = "";
    const selectedTab = document.querySelector(this.selectedTab);
    selectedTab.classList.remove(this.selectedTabName);
  }

  clickCorrectTab(event){
    event.target.classList.add(this.selectedTabName);
    this.currentTabId += event.target.id;
  }

  clickTabDelegation(){
    let correctedTarget = event.target.closest("li.storeTab");
    correctedTarget.classList.add(this.selectedTabName);
    this.currentTabId += correctedTarget.id;
  }

  showAndHideTabContent(){
    const nextContentName = this.generalContentPrefix + this.currentTabId;
    const nextContent = document.querySelector(nextContentName);
    const currentContent = document.querySelector(this.selectedContent);
    currentContent.classList.remove(this.selectedContentName);
    nextContent.classList.add(this.selectedContentName);
  }

}