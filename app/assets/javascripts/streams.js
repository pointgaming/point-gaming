var PointGaming = PointGaming || {};

(function () {
    "use strict";

    var streamId;

    $(document).on("ready page:load", function () {
        streamId = $("#stream-wrapper").data("stream-id");

        if (streamId) {
            PointGaming.subscribe("stream", streamId);
        } else {
            PointGaming.unsubscribe("stream");
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
