var PointGaming = PointGaming || {};

(function () {
    "use strict";

    var resetModal = function () {
        var match = PointGaming.getCurrentMatch();
    };

    PointGaming.on("message", "update:bet", function (data) {
        PointGaming.reloadStreamTable("bets");
    });

    PointGaming.on("message", "update:match", function (data) {
        PointGaming.reloadStreamTable("bets");
        resetModal();
    });
}());
