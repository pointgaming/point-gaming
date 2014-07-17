var PointGaming = PointGaming || {};

(function () {
    "use strict";

    $(document).on("ready", function () {
        var userId = $("#user").data("id");

        if (userId) {
            PointGaming.subscribe("user", userId);
        } else {
            PointGaming.unsubscribe("user");
        }
    });

    PointGaming.on("message", "points", function (data) {
        $("#user-points").html(data.points);
    });
}());
