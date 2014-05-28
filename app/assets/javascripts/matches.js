(function () {
    "use strict";

    var streamUrl = function () {
            var streamId = $("#stream-wrapper").data("stream-id");
            return "/streams/" + streamId;
        },
        reloadTable = function () {
            $.ajax({
                url: streamUrl() + "/matches",
                method: "GET",

                success: function (data) {
                    $("#matches").replaceWith(data);
                }
            });
        };

    $(function () {
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
        reloadTable();
    });

    $(document).on("ajax:error", "form#new-match-form", function () {
        $("button.create-match").popover({
            content: "Finalize previous matches first.",
            placement: "top"
        }).popover("show");

        setTimeout(function () {
            $("button.create-match").popover("destroy");
        }, 2000);

        reloadTable();
    });
}());
