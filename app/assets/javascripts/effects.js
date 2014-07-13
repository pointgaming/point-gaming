(function () {
    "use strict";

    $(document).on("ready page:load", function () {
        $("a[rel~=popover], .has-popover").popover();
        $("a[rel~=tooltip], .has-tooltip").tooltip();

        $(".markdown-area").markdown({
            iconlibrary: "fa"
        });
    });

    $(document).on("hidden.bs.modal", ".modal", function () {
        $(this).find("form")[0].reset();
        $(".odds-slider").slider("value", 0);
    })
}());
