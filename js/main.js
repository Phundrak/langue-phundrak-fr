/*jshint esversion: 6 */

var light = false;

window.onload = function() {
    $("#table-of-contents").remove();
    reorganize_html();
    create_theme_switcher();
    roll_elems();
};

function roll_elems() {
    // Add the possibility for all headers to roll what follows them
    ['h2', 'h3', 'h4', 'h5', 'h6'].forEach(htitle => {
        $(htitle).addClass('rolled');
    });

    // Except for the footnotes
    $('.footnotes').removeClass('rolled');

    // // Make the rollable headers actually rollable and rolled
    $('.header-container').each(function($header) {
        $header = $(this);
        $header.click(function() {
            $header.nextAll().each(function() {
                $(this).slideToggle(500);
            });
            $header.find('>:first-child').toggleClass('unrolled');
            $header.find('>:first-child').toggleClass('rolled');
        });
    });
}

function reorganize_html() {
    // Move the title out of the content div
    $('#content').before('<div class="h1-container"><div class="highlight-h1"></div></div>');
    $('.title').prependTo($('.h1-container'));

    // Move the postamble in the content div
    $('#postamble').appendTo($('#content'));

    // Move to container the various heads
    [2, 3, 4, 5, 6].forEach(htitle => {
        $('h' + htitle).each(function() {
            $header = $(this);
            $header.before('<div class="header-container"><div class="highlight-h' +
                htitle + '"></div></div>');
            $header.prependTo($header.prev());
        });
        $('.outline-text-' + htitle).each(function(){
            if(isEmpty($(this))) {
                $(this).remove();
            }
        });
    });

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
    if (Cookies.get('theme') == 'light') {
        $('body').append('<div class="themeBtn"><i class="fas fa-moon"></i></div>');
        $('head').append('<link id="theme" rel="stylesheet" href="./css/light.css">');
    } else {
        $('body').append('<div class="themeBtn"><i class="fas fa-sun"></i></div>');
        $('head').append('<link id="theme" rel="stylesheet" href="./css/dark.css">');
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

function isEmpty( el ){
    return !$.trim(el.html())
}
