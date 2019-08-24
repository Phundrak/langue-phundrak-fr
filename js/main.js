window.onload = function() {
    // Add the possibility for all headers to roll what follows them
    ['h2', 'h3', 'h4', 'h5', 'h6'].forEach(function(htitle){
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

    // Move the title out of the content div
    $('.title').prependTo($("body"));

    // Move the postamble in the content div
    $('#postamble').appendTo($("#content"));

    // Move each table in a div to handle large tables' overflow
    $('table').each(function(){
        $table = $(this);
        $table.before('<div class="largetable"></div>');
        $table.prependTo($table.prev());
    });
}
