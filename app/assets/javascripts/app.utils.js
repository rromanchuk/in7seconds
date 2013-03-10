app.dom = {};
app.dom.win = $(window);
app.dom.doc = $(document);
app.dom.html = $('html');
app.dom.body = $('body');
app.dom.header = $('#l-header');
app.dom.content = $('#l-content');
app.dom.footer = $('#l-footer');

app.browser = {
    isOpera: ('opera' in window),
    isFirefox: (navigator.userAgent.indexOf('Firefox') !== -1),
    isIOS: (function() {
        if (!$.os.ios) {
            return false;
        }
        if(/OS [2-4]_\d(_\d)? like Mac OS X/i.test(navigator.userAgent)) {
            return navigator.userAgent.match(/OS ([2-4])_\d(_\d)? like Mac OS X/i)[1];
        } else if(/CPU like Mac OS X/i.test(navigator.userAgent)) {
            return 1;
        } else {
            return navigator.userAgent.match(/OS ([5-9])(_\d)+ like Mac OS X/i)[1];
        }

        return 0;
    })(),
    isAndroid: $.os.android ? parseInt(/Android\s([\d\.]+)/g.exec(navigator.appVersion)[1], 10) : false,
    isIE: (function() {
        if (!!document.all) {
            if (!!window.atob) return 10;
            if (!!document.addEventListener) return 9;
            if (!!document.querySelector) return 8;
            if (!!window.XMLHttpRequest) return 7;
        }

        return false;
    })(),
    isTouchDevice: $.os.touch
};
app.now = new Date();

app.api = function(name, params) {
    return app.endpoints[name] ? window.helpers.makeURL(app.endpoints[name], params || void 0) : '';
};

// Global utility functions
app.log = function() {
    if (app.env.debug && 'console' in window) {
        (arguments.length > 1) ? console.log(Array.prototype.slice.call(arguments)) : console.log(arguments[0]);
    }
};
app.e = function(e) {
    (typeof e.preventDefault === 'function') && e.preventDefault();
    (typeof e.stopPropagation === 'function') && e.stopPropagation();
};

app.utils = {};
// app.utils.translate = function() {
//     if (app.browser.isAndroid && app.browser.isAndroid >= 4) {
//         return function(x, y) {
//             return 'translate3d(' + x + ', ' + y + ', 0)';
//         };
//     }
//
//     if (!app.browser.isIOS) {
//         return function(x, y) {
//             return 'translate(' + x + ', ' + y + ')';
//         };
//     }
//     else {
//         return function(x, y) {
//             return 'translate3d(' + x + ', ' + y + ', 0)';
//         };
//     }
// }();
(function(){
    var _supportsInterface = function(isRaw) {
        var div = document.createElement('div'),
            vendors = 'Ms O Moz Webkit'.split(' '),
            len = vendors.length,
            memo = {};

        return function(prop) {
            var key = prop;

            if (typeof memo[key] !== 'undefined') {
                return memo[key];
            }

            if (typeof div.style[prop] !== 'undefined') {
                memo[key] = prop;
                return memo[key];
            }

            prop = prop.replace(/^[a-z]/, function(val) {
                return val.toUpperCase();
            });

            for (var i = len - 1; i >= 0; i--) {
                if (typeof div.style[vendors[i] + prop] !== 'undefined') {
                    if (isRaw) {
                        memo[key] = ('-' + vendors[i] + '-' + prop).toLowerCase();
                    }
                    else {
                        memo[key] = vendors[i] + prop;
                    }
                    return memo[key];
                }
            }

            return false;
        };
    };

    app.utils.supports = _supportsInterface(false);
    app.utils.__supports = _supportsInterface(true);
})();
