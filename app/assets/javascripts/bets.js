var PointGaming = PointGaming || {};

(function () {
    "use strict";

    var resetModal = function () {
            var match = PointGaming.getCurrentMatch();
            // TODO
        },
        
        updateSlider = function () {
            var points = parseInt($("#bet_points").val(), 10),
                value = $(".odds-slider").slider("value"),
                winnings;

            $(".bet-points").html(points);

            if (value === -3) {
                winnings = points + (points * 0.5);
            } else if (value === -2) {
                winnings = points + (points * 0.25);
            } else if (value === -1) {
                winnings = points + (points * 0.1);
            } else if (value === 0) {
                winnings = points;
            } else if (value === 1) {
                winnings = points * 0.5;
            } else if (value === 2) {
                winnings = points * 0.25;
            } else if (value === 3) {
                winnings = points * 0.1;
            }

            $(".bet-winnings").html(winnings);
        };

    PointGaming.on("message", "update:bet", function (data) {
        PointGaming.reloadStreamTable("bets");
    });

    PointGaming.on("message", "update:match", function (data) {
        PointGaming.reloadStreamTable("bets");
        resetModal();
    });

    $(document).on("ajax:success", "form#new-bet-form", function () {
        $("#new-bet-modal").modal("hide");
    });

    $(document).on("click", "a.accept-bet", function () {
        var betId = $(this).parent("td").parent("tr").data("bet-id");

        $.ajax({
            url: PointGaming.streamUrl() + "/bets/" + betId,
            method: "PUT"
        });

        return false;
    });

    $(document).on("keyup", "#bet_points", updateSlider);

    $(document).on("ready page:load", function () {
        $(".odds-slider").slider({
            min: -3,
            value: 0,
            max: 3,
            step: 1,
            slide: updateSlider,
            change: updateSlider
        });
    });
}());
