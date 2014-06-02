(function () {
    "use strict";

    var template,
        channelId,
        sendMessage = function () {
            var input = $("#chat-input").val(),
                data = {
                    action: "chat",
                    message: input
                };

            PointGaming.send(data);

            $("#chat-input").val("");

            return false;
        };

    PointGaming.on("close", function () {
        $("#chat .panel-body").append("<strong>You have disconnected.</strong><p></p>");
    });
    PointGaming.on("message", "chat", function (data) {
        var panel = $("#chat .panel-body");

        template = " " +
            "<div class='message' style='padding-top:0px'>" +
                "<a href='/users/" + data.slug + "'>" +
                    data.username +
                "</a>" +
                ": " + data.message +
            "</div>";

        panel.append(template);
        panel.scrollTop(panel[0].scrollHeight);
    });

    $(document).on("click", "#send-chat-input", sendMessage);
    $(document).on("keypress", "#chat-input", function (e) {
        if (e.keyCode === 13) {
            sendMessage();
            e.preventDefault();
        }
    });
}());
