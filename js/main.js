/*jshint esversion: 6 */

window.onload = function() {
    reorganize_html();
    create_theme_switcher();
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
    $('head').append('<link id="theme" rel="stylesheet" href="./css/'
        .concat(light ? 'light' : 'dark').concat('.css">'));

    // switch CSS files and button icon, set new cookie on theme switcher click
    $('.themeBtn').click(function() {
        console.log("Theme change");
        var light = !isThemeLight();
        console.log(light);
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
