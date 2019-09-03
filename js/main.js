/*jshint esversion: 6 */

window.onload = function() {
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
    // Remove table of contents
    $("#table-of-contents").remove();

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
        $('.outline-text-' + htitle).each(function() {
            if (isEmpty($(this))) {
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
