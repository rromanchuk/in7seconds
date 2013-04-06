(function(exports) {
    exports.makeURL = function(url, params) {
        var matches = url.match(/[:|*]\w+/g);

        if (typeof params === 'string' || typeof params === 'number') { // only change first (and only) parameter
            url = url.replace(matches[0], params);
        }
        else if (params && matches) {
            for (var i = 0, l = matches.length; i < l; i++) {
                url = url.replace(matches[i], params[matches[i].slice(1)] || '');
            }
        }

        return url;
    };
    exports.stripTags = function(str) {
      if (typeof str !== 'string') return '';
      return str.replace(/(<([^>]+)>)/ig, '');
    };
    exports.dateToYMD = function(date) {
        return date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2);
    };
    exports.dateFromYMD = function(ymd) {
        var darr = ymd.split('-');
        return new Date(+darr[0], +darr[1] - 1, +darr[2]);
    };
    // exports.dateFormatFromYMD = function(ymd) {
    //     date = exports.dateFromYMD(ymd);
    //     return [('0' + date.getDate()).slice(-2), lang['weekdays_short'][date.getDay()], lang['months_inflected'][date.getMonth()]];
    // };
    exports.dateGetDaysDiff = function(date1, date2) {
        return Math.abs((+exports.extractDate(date1) - +exports.extractDate(date2)) / (1000 * 60 * 60 * 24));
    };

    exports.shortenString = function (str, len, pos) {
        var lim = ((len - 3) / 2) | 0,
            res = str;

        if (str.length > len) {
            switch(pos) {
                case 'left':
                    res = '...' + str.slice(3 - len);
                    break;
                case 'right':
                    res = str.slice(0, len - 3) + '...';
                    break;
                default:
                    res = str.slice(0, lim) + '...' + str.slice(-lim);
                    break;
            }
        }

        return res;
    };
    exports.capfirst = function (string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    };

    exports.makeEnding = function(number, wordForms) {
        var order = number % 100;

        if ((order > 10 && order < 20) || (number === 0)) {
            return wordForms[2];
        }
        else {
            switch (number % 10) {
                case 1: return wordForms[0];
                case 2:
                case 3:
                case 4: return wordForms[1];
                default: return wordForms[2];
            }
        }
    };

    // Just like the Django filter
    exports.choosePlural = function (number, endings) {
        return number + ' ' + exports.makeEnding.apply(this, arguments);
    };

    // Price, wrapper, num of remainder chars, delimeter and thousands delimeter
    exports.formatNum = function(p, w, c, d, t) {
        var n = isNaN(+p) ? 0 : +p,
            c = (typeof c === 'undefined') ? 0 : c,
            d = (typeof d === 'undefined') ? "." : d,
            t = (typeof t === 'undefined') ? " " : t,
            s = n < 0 ? '-' : '',
            i = parseInt(n = Math.abs(+n || 0).toFixed(c), 10) + "",
            j = (j = i.length) > 3 ? j % 3 : 0,
            r;

        if (typeof w === 'string' && w.length > 0) {
            r = s + (j ? i.substr(0, j) + t : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, '$1' + t) + '<' + w + '>' + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : '') + '<\/' + w + '>';
        }
        else {
            r = s + (j ? i.substr(0, j) + t : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, '$1' + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : '');
        }

        return r;
    };

    exports.extractDate = function(date) {
        if (typeof date === 'number') {
            date = new Date(date);
        }
        if (typeof date === 'string') {
            date = exports.dateFromYMD(date);
        }

        return date;
    };

    // exports.humanizeDate = function(date) {
    //     date = exports.extractDate(date);
    //     return date.getDate() + ' ' + lang['months_inflected'][date.getMonth()];
    // };
    // exports.humanizeDatesSpan = function(date1, date2) {
    //     date1 = exports.extractDate(date1);
    //     date2 = exports.extractDate(date2);

    //     if (date1.getMonth() === date2.getMonth()) {
    //         return date1.getDate() + ' &ndash; ' + date2.getDate() + ' ' + lang['months_inflected'][date2.getMonth()];
    //     }

    //     return date1.getDate() + ' ' + lang['months_inflected'][date1.getMonth()] + ' &ndash; ' + date2.getDate() + ' ' + lang['months_inflected'][date2.getMonth()];
    // };

    exports.toRad = function(n) {
        return n * Math.PI / 180;
    };

    exports.getDistance = function (lat1, lon1, lat2, lon2) {
        var R = 6371; // km
        var dLat = exports.toRad(lat2 - lat1);
        var dLon = exports.toRad(lon2 - lon1);
        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(exports.toRad(lat1)) * Math.cos(exports.toRad(lat2)) *
              Math.sin(dLon / 2) * Math.sin(dLon / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    };

    // exports.shortenString = function (str, len, pos) {
    //     var lim = ((len - 3) / 2) | 0,
    //         res = str;

    //     if (str.length > len) {
    //         switch(pos) {
    //             case 'left':
    //                 res = '...' + str.slice(3 - len);
    //                 break;
    //             case 'right':
    //                 res = str.slice(0, len - 3) + '...';
    //                 break;
    //             default:
    //                 res = str.slice(0, lim) + '...' + str.slice(-lim);
    //                 break;
    //         }
    //     }

    //     return res;
    // };

    // exports.sanitizeString = function(str) {
    //     return $('<div/>').text(str).html();
    // };

    // exports.parseURL = function (url) {
    //     var a =  document.createElement('a');
    //     a.href = url;
    //     return {
    //         source: url,
    //         protocol: a.protocol.replace(':',''),
    //         host: a.hostname,
    //         port: a.port,
    //         query: a.search,
    //         params: (function() {
    //             var ret = {},
    //                 seg = a.search.replace(/^\?/,'').split('&'),
    //                 len = seg.length, i = 0, s;
    //             for (; i < len; i++) {
    //                 if (!seg[i]) { continue; }
    //                 s = seg[i].split('=');
    //                 ret[s[0]] = s[1];
    //             }
    //             return ret;
    //         })(),
    //         file: (a.pathname.match(/\/([^\/?#]+)$/i) || [,''])[1],
    //         hash: a.hash.replace('#',''),
    //         path: a.pathname.replace(/^([^\/])/,'/$1'),
    //         relative: (a.href.match(/tps?:\/\/[^\/]+(.+)/) || [,''])[1],
    //         segments: a.pathname.replace(/^\//,'').split('/')
    //     };
    // };


    // exports.monthLabels = ['январь', 'февраль', 'март', 'апрель',
    //                            'май', 'июнь', 'июль', 'август', 'сентябрь',
    //                            'октябрь', 'ноябрь', 'декабрь'];
    // exports.monthLabelsAlt = ['января', 'февраля', 'марта', 'апреля',
    //                            'мая', 'июня', 'июля', 'августа', 'сентября',
    //                            'октября', 'ноября', 'декабря'];

    // exports.pureDate = function(date) {
    //     return new Date(date.getFullYear(), date.getMonth(), date.getDate());
    // };
    // exports.dateToYMD = function(date) {
    //     return date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2);
    // };
    // exports.YMDToDate = function(ymd) {
    //     var darr = ymd.split('-');
    //     return new Date(+darr[0], +darr[1] - 1, +darr[2]);
    // };
    // exports.YMDToDateMonth = function(ymd) {
    //     var darr = ymd.split('-');
    //     return new Date(+darr[0], +darr[1] - 1, 1);
    // };
    // exports.getWeeksNum = function(year, month) {
    //     var daysNum = exports.getDaysNum(year, month),
    //         fDayO = new Date(year, month, 1).getDay(),
    //         fDay = fDayO ? (fDayO - 1) : 6,
    //         weeksNum = Math.ceil((daysNum + fDay) / 7);
    //     return weeksNum;
    // };
    // exports.getDaysNum = function(year, month) { // nMonth is 0 thru 11
    //     return 32 - new Date(year, month, 32).getDate();
    // };
    // exports.extractDate = function(date) {
    //     if (typeof date === 'number') {
    //         date = new Date(date);
    //     }
    //     if (typeof date === 'string') {
    //         date = exports.YMDToDate(date);
    //     }

    //     return date;
    // };
    // exports.humanizeDate = function(date) {
    //     date = exports.extractDate(date);
    //     return date.getDate() + ' ' + exports.monthLabelsAlt[date.getMonth()];
    // };
    // exports.humanizeDatesSpan = function(date1, date2) {
    //     date1 = exports.extractDate(date1);
    //     date2 = exports.extractDate(date2);

    //     if (date1.getMonth() === date2.getMonth()) {
    //         return date1.getDate() + ' &ndash; ' + date2.getDate() + ' ' + exports.monthLabelsAlt[date2.getMonth()];
    //     }

    //     return date1.getDate() + ' ' + exports.monthLabelsAlt[date1.getMonth()] + ' &ndash; ' + date2.getDate() + ' ' + exports.monthLabelsAlt[date2.getMonth()];
    // };
    // exports.getDaysDiff = function(date1, date2) {
    //     return Math.abs((+date1 - +date2) / (1000 * 60 * 60 * 24));
    // };
    // exports.getHoursDiff = function(date1, date2) {
    //     return Math.abs((+date1 - +date2) / (1000 * 60 * 60));
    // };
    // exports.getMinutesDiff = function(date1, date2) {
    //     return Math.abs((+date1 - +date2) / (1000 * 60));
    // };
    // exports.getSecondsDiff = function(date1, date2) {
    //     return Math.abs((+date1 - +date2) / (1000));
    // };
    // exports.humanizeDuration = function(ts) {
    //     var diff = ts / 60,
    //         hours = Math.floor(diff / 60),
    //         minutes = diff % 60;

    //     if (minutes) {
    //         return hours + ' ч. ' + minutes + ' мин.';
    //     }

    //     return hours + ' ч.';
    // };
    // exports.humanizeTimeSince = function(timestamp) {
    //     var diff = Math.ceil(exports.getSecondsDiff(+new Date(), timestamp));

    //     if (!diff) {
    //         return '<span class="f-humanized-date">сейчас</span>';
    //     }
    //     if (diff < 60) {
    //         return '<span class="f-humanized-date"><b>' + diff + '</b> ' + exports.makeEnding(diff, ['секунду', 'секунды', 'секунд']) + ' назад</span>';
    //     }
    //     if (diff < 60 * 60) {
    //         diff = Math.ceil(diff / 60);
    //         return '<span class="f-humanized-date"><b>' + diff + '</b> ' + exports.makeEnding(diff, ['минуту', 'минуты', 'минут']) + ' назад</span>';
    //     }
    //     if (diff < 60 * 60 * 24) {
    //         diff = Math.ceil(diff / (60 * 60));
    //         return '<span class="f-humanized-date"><b>' + diff + '</b> ' + exports.makeEnding(diff, ['час', 'часа', 'часов']) + ' назад</span>';
    //     }

    //     var date = new Date(timestamp);

    //     return '<span class="f-humanized-date"><b>' + date.getDate() + '</b> ' + exports.monthLabelsAlt[date.getMonth()] + '</span>';
    // };

    // if (!!document.all) {// IE
    //     exports.formatDate = function(dateString) {
    //         var date = new Date((dateString + '').replace('-', '/').replace('T', ' '));
    //         return date.getDate() + ' ' + exports.monthLabelsAlt[date.getMonth()] + ' ' + date.getFullYear();
    //     };
    //     exports.formatDateSince = function(dateString) {
    //         return exports.humanizeTimeSince(Date.parse((dateString + '').replace('-', '/').replace('T', ' ')));
    //     };
    // }
    // else {
    //     exports.formatDate = function(dateString) {
    //         var date = new Date(dateString);
    //         return date.getDate() + ' ' + exports.monthLabelsAlt[date.getMonth()] + ' ' + date.getFullYear();
    //     };
    //     exports.formatDateSince = function(dateString) {
    //         return exports.humanizeTimeSince(typeof dateString === 'number' ? dateString : Date.parse(dateString));
    //     };
    // }
    // exports.starMap = [
    //     '<i class="f-stars">★<s>☆☆☆☆</s></i>',
    //     '<i class="f-stars">★★<s>☆☆☆</s></i>',
    //     '<i class="f-stars">★★★<s>☆☆</s></i>',
    //     '<i class="f-stars">★★★★<s>☆</s></i>',
    //     '<i class="f-stars">★★★★★</i>'
    // ];
    // exports.formatStars = function(num) {
    //     return exports.starMap[+num - 1];
    // };
})(typeof exports === 'undefined' ? this['helpers'] = {} : exports);
