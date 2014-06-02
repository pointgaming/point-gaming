(function () {
    "use strict";

    var channelId;

    $(function () {
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
