$(function () {
    "use strict";

    $("a[rel~=popover], .has-popover").popover();
    $("a[rel~=tooltip], .has-tooltip").tooltip();

    $(".markdown-area").markdown({
        iconlibrary: "fa"
    });
});
