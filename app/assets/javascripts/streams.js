var PointGaming = PointGaming || {};

(function () {
    "use strict";

    var channelId;

    $(document).on("ready page:load", function () {
        channelId = $("#stream-wrapper").data("stream-id");

        if (channelId) {
            PointGaming.subscribe("stream." + channelId);
        }

        $("#new-stream-form").validate({
            rules: {
                "stream[name]": {
                    required: true,
                    remote: "/streams/validate_name"
                }
            }
        });
    });
}());
