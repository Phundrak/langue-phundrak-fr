/*
  Copyright (C) 2019-2020  Lucien Cartier-Tilet

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as
  published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */

/*jshint esversion: 6 */

window.onload = function() {
    reorganize_html();
    create_theme_switcher();
    console.log("JS loaded!");
};

function reorganize_html() {
    // Move the postamble in the content div
    $('#content').append('<hr>');
    $('#postamble').appendTo($('#content'));

    // Move each table in a div to handle large tables' overflow
    $('table').each(function() {
        $table = $(this);
        $table.before('<div class="largetable"></div>');
        $table.prependTo($table.prev());
    });
}

function create_theme_switcher() {
    // set the correct CSS depending on the cookie, dark is default
    var light = isThemeLight();
    $('body').append('<div class="themeBtn"><i class="fas fa-'
        .concat(light ? 'moon' : 'sun').concat('"></i></div>'));
    $('head').append('<link id="theme" rel="stylesheet" href="https://langue.phundrak.fr/css/'
        .concat(light ? 'light' : 'dark').concat('.css">'));

    // switch CSS files and button icon, set new cookie on theme switcher click
    $('.themeBtn').click(function() {
        var light = !isThemeLight();
        $("#theme").first().attr('href', './css/'
            .concat(light ? 'light' : 'dark')
            .concat('.css'));
        $('.themeBtn').html('<i class="fas fa-'
            .concat(light ? 'moon' : 'sun')
            .concat('"></i>'));
        Cookies.set('light-theme', light ? 'true' : 'false');
    });
}

function isThemeLight() {
    // set the css and button depending on the cookie found, dark is default
    var light;
    switch (Cookies.get('light-theme')) {
        case 'true':
            light = true;
            break;
        case null: // If no theme cookie is found, set dark by default
            Cookies.set('light-theme', false);
            /* falls through */
        default:
            light = false;
            break;
    }
    return light;
}

function isEmpty(el) {
    return !$.trim(el.html());
}
