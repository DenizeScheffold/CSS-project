function myFunction() { 

  var x = document.getElementById("myTopnav"); 
  
  if (x.className === "topnav") { 
  
  x.className += " responsive"; 
  
  } else { 
  
  x.className = "topnav"; 
  
  } 
  
  }
  window.addEventListener("DOMContentLoaded", function (e) {
    var stage = document.getElementById("stage");
    var fadeComplete = function (e) { stage.appendChild(arr[0]); };
    var arr = stage.getElementsByTagName("a");
    for (var i = 0; i < arr.length; i++) {
      arr[i].addEventListener("animationend", fadeComplete, false);
    }
  }, false);
