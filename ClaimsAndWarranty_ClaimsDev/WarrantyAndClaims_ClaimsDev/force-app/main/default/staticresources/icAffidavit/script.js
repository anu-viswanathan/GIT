load();
function load() {
  function receiveMessage(event) {
    if (event.data.isOpened) {
      var head = document.head,
        link = document.createElement("link");

      link.type = "text/css";
      link.rel = "stylesheet";
      link.href = event.data.styles;
      link.id = "affidavitStyles";
      head.appendChild(link);
    }
    if (!event.data.isOpened) {
      try {
        if (document.getElementById("affidavitStyles")) {
          document.getElementById("affidavitStyles").remove();
        }
      } catch (error) {
        console.log(error);
      }
    }
  }
  window.addEventListener("message", receiveMessage, false);
}
