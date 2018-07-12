var fetchIcons = function(){
    var possibleIcons = []
    var nodeList = document.getElementsByTagName("link");
    for (var i = 0; i < nodeList.length; i++) {
        var node = nodeList[i]
        if ((node.getAttribute("rel") == "apple-touch-icon") || (node.getAttribute("rel") == "apple-touch-icon-precomposed")) {
            possibleIcons.push({ "href": node.getAttribute("href"),
                               "size": node.getAttribute("sizes")
                               });
        }
    }
    window.webkit.messageHandlers.didFetchIcons.postMessage(possibleIcons);
}

fetchIcons();
