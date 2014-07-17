var PointGaming = PointGaming || {};

(function () {
    "use strict";

    var streamId;

    $(document).on("ready", function () {
        streamId = PointGaming.streamId();

        if (streamId) {
            PointGaming.subscribe("stream", streamId);
        } else {
            PointGaming.unsubscribe("stream");
        }

        $("#new-stream-form, #update-stream-form").validate({
            rules: {
                "stream[name]": {
                    required: true,
                    remote: "/streams/validate_name"
                }
            }
        });
    });

    $(document).on("click", "#destroy-stream-button", function () {
        $.ajax({
            url: PointGaming.streamUrl(),
            type: "DELETE"
        });
    });
}());
