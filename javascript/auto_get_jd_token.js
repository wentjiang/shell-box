function getCookiesFormatted(cookieNames) {
    var cookiesFormatted = [];

    var allCookies = document.cookie;

    var cookieArray = allCookies.split(';');

    for (var i = 0; i < cookieNames.length; i++) {
        var currentCookieName = cookieNames[i].trim();
        var cookieFound = false;

        for (var j = 0; j < cookieArray.length; j++) {
            var cookie = cookieArray[j].trim();

            if (cookie.indexOf(currentCookieName + '=') === 0) {
                cookiesFormatted.push(cookie);
                cookieFound = true;
                break;
            }
        }

        if (!cookieFound) {
            cookiesFormatted.push(currentCookieName + '=undefined');
        }
    }

    return cookiesFormatted.join(';');
}

var cookieNames = ["pt_key", "pt_pin"];
var formattedCookies = getCookiesFormatted(cookieNames);

console.log("格式化后的cookie字符串：" + formattedCookies);
