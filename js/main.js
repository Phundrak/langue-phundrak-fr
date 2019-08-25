/*jshint esversion: 6 */

var light = false;

window.onload = function() {
    roll_elems();
    reorganize_html();
    create_theme_switcher();
};

function roll_elems() {
    // Add the possibility for all headers to roll what follows them
    ['h2', 'h3', 'h4', 'h5', 'h6'].forEach(htitle => {
        $(htitle).addClass('rolled');
    });

    // Except for the footnotes
    $('.footnotes').removeClass('rolled');

    // Make the rollable headers actually rollable and rolled
    $('.rolled').click(function() {
        $header = $(this);
        $header.nextAll().each(function() {
            $(this).slideToggle(500);
        });
        $header.toggleClass('unrolled');
        $header.toggleClass('rolled');
    });
}

function reorganize_html() {
    // Move the title out of the content div
    $('.title').prependTo($('body'));

    // Move the postamble in the content div
    $('#postamble').appendTo($('#content'));

    // Move each table in a div to handle large tables' overflow
    $('table').each(function() {
        $table = $(this);
        $table.before('<div class="largetable"></div>');
        $table.prependTo($table.prev());
    });
}

function create_theme_switcher() {
    // If no theme cookie is found, set dark by default
    if (Cookies.get('theme') == null) {
        Cookies.set('theme', 'dark');
    }

    // set the css and button depending on the cookie found, dark is default
    if (Cookies.get('theme') == 'dark') {
        $('body').append('<div class="themeBtn"><i class="fas fa-sun"></i></div>');
    } else {
        $('body').append('<div class="themeBtn"><i class="fas fa-moon"></i></div>');
        $('link[href="./css/dark.css"]').attr('href', './css/light.css');
    }

    // switch CSS files and button icon, set new cookie
    $('.themeBtn').click(function() {
        if (Cookies.get('theme') == 'dark') {
            $('link[href="./css/dark.css"]').attr('href', './css/light.css');
            $('.themeBtn').html('<i class="fas fa-moon"></i>');
            Cookies.set('theme', 'light');
        } else {
            $('link[href="./css/light.css"]').attr('href', './css/dark.css');
            $('.themeBtn').html('<i class="fas fa-sun"></i>');
            Cookies.set('theme', 'dark');
        }
    });
}
