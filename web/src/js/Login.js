



export class Login {
  constructor(){
    this.pw = "";
  }
  }

  init(){
    getInputInfo().then(sendLoginInfo.then(checkValidity))
  }

  sendLoginInfo(userId){
    return new Promise(function (resolve) {
      var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          document.getElementById("demo").innerHTML = xhttp.responseText;
        }
      };
      xhttp.open("GET", SERVER_BASE_URL + "/cf/" + userId["userId"], true);
      xhttp.send();
    })

  }

  getInputInfo(){
    return new Promise(function (resolve) {
      const idInfo = document.querySelector(".loginIDInput").value;
      const pwInfo = document.querySelector(".longinPWInput").value;
      const packet = {"userId" : idInfo);
      this.pw = pwInfo;
      resolve(packet);
    });
  }

  checkValidity(){

  }


}





