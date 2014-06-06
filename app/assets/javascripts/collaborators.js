var PointGaming = PointGaming || {};

(function () {
    "use strict";

    var streamUrl = function () {
            var streamId = $("#stream-wrapper").data("stream-id");
            return "/streams/" + streamId;
        };

    $(document).on("ready page:load", function () {
        $("#new-collaborator").select2({
            placeholder: "Search username...",
            minimumInputLength: 3,
            id: function (object) {
                return object._id["$oid"];
            },
            ajax: {
                url: "/users/search.json",
                dataType: "json",
                quietMillis: 250,

                data: function (term) {
                    return {
                        query: term
                    };
                },

                results: function (data, page) {
                    return {
                        results: data,
                        more: false
                    };
                }
            },
            formatResult: function (object) {
                return object.username;
            },
            escapeMarkup: function (m) {
                return m;
            }
        });

        $("#new-collaborator").on("select2-selecting", function (e) {
            $.ajax({
                url: streamUrl() + "/collaborators",
                method: "POST",
                data: { user_id: e.val }
            });

            e.preventDefault();
            PointGaming.reloadStreamTable("collaborators");

            $("#new-collaborator").select2("close");

            return false;
        });
    });

    $(document).on("click", ".remove-collaborator", function () {
        if (confirm("Are you sure?") === true) {
            $.ajax({
                url: $(this).attr("href"),
                method: "DELETE"
            });

            PointGaming.reloadStreamTable("collaborators");

            return false;
        }
    });
}());
