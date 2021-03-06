var PointGaming = PointGaming || {};

(function () {
    "use strict";

    var updateButtonState = function (state) {
            var button = $("#match-button"),
                icon = button.find("span.btn-label"),
                text = button.find("span.match-button-text");

            if (state === "initialized") {
                button.removeClass("hidden");
                button.removeClass("btn-danger");
                button.addClass("btn-success");
                icon.removeClass("fa-stop");
                icon.addClass("fa-play");
                text.html("Start Match");
            } else if (state === "started") {
                button.removeClass("hidden");
                button.addClass("btn-danger");
                button.removeClass("btn-success");
                icon.addClass("fa-stop");
                icon.removeClass("fa-play");
                text.html("Stop Match");
            } else if (state === "finalized") {
                button.addClass("hidden");
            }
        };

    $(document).on("ready", function () {
        $("#new-match-form").validate({
            rules: {
                "match[player1]": {
                    required: true
                },
                "match[player2]": {
                    required: true
                },
                "match[game]": {
                    required: true
                }
            }
        });
    });

    $(document).on("ajax:success", "form#new-match-form", function () {
        $("#new-match-modal").modal("hide");
        PointGaming.reloadStreamTable("matches");
        updateButtonState("initialized");
    });

    $(document).on("ajax:error", "form#new-match-form", function () {
        $("button.create-match").popover({
            content: "Finalize previous matches first.",
            placement: "top"
        }).popover("show");

        setTimeout(function () {
            $("button.create-match").popover("destroy");
        }, 2000);

        PointGaming.reloadStreamTable("matches");
    });

    $(document).on("click", "#match-button", function () {
        var text = $(this).find("span.match-button-text");

        $.ajax({
            url: PointGaming.streamUrl() + "/matches/active",
            method: "PUT",

            success: function (data) {
                var state = data.workflow_state,
                    player1 = data.player1,
                    player2 = data.player2,
                    bootbox = window.bootbox,
                    declareWinner = function (winner) {
                        $.ajax({
                            url: PointGaming.streamUrl() + "/matches/active",
                            method: "PUT",
                            data: {
                                match: {
                                    winner: winner
                                }
                            }
                        });
                    };

                if (state) {
                    if (state === "stopped") {
                        bootbox.dialog({
                            message: "Select the winner of the match. Bets " +
                                "made will be finalized and awarded to the " +
                                "viewers who voted for the winner.",
                            title: "Select Winner",
                            buttons: {
                                success: {
                                    label: player1,
                                    className: "btn-primary",
                                    callback: function () {
                                        declareWinner(1);
                                    }
                                },
                                danger: {
                                    label: player2,
                                    className: "btn-primary",
                                    callback: function () {
                                        declareWinner(2);
                                    }
                                },
                                main: {
                                    label: "Nullify/Draw",
                                    className: "btn-danger",
                                    callback: function () {
                                        declareWinner(null);
                                    }
                                }
                            },
                            className: "bootbox-sm"
                        });
                    } else {
                        updateButtonState(data.workflow_state);
                    }
                }
            }
        });
    });

    PointGaming.on("message", "update:match", function (data) {
        PointGaming.reloadStreamTable("matches");
        PointGaming.reloadStreamTable("bets");
        updateButtonState(PointGaming.getCurrentMatch().workflow_state);
    });
}());
