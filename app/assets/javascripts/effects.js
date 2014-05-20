$(function () {
    "use strict";

    $("a[rel~=popover], .has-popover").popover();
    $("a[rel~=tooltip], .has-tooltip").tooltip();

    $("#bs-markdown-example").markdown({
        iconlibrary: "fa"
    });
});
