(function () {
    "use strict";

    var url,
        socket,
        template,
        channelId,
        sendMessage = function () {
            var input = $("#chat-input").val(),
                data = {
                    message: input
                };

            socket.send(JSON.stringify(data));

            $("#chat-input").val("");

            return false;
        };

    $(function () {
        channelId = $("#chat").data("channel-id");
            
        if (channelId) {
            url = "ws";

            if (window.location.protocol.match("https")) {
                url += "s";
            }

            url += "://" + window.location.host + "/chat?channel_id=";

            socket = new WebSocket(url + channelId);
            socket.onmessage = function (e) {
                var data = JSON.parse(e.data),
                    panel = $("#chat .panel-body");

                template = " " +
                    "<div class='message'>" +
                        "<img alt='' class='message-avatar' src='" +
                            data.avatar +
                        "' />" +
                        "<div class='message-body'>" +
                            "<div class='message-heading'>" +
                                "<a href='/users/" + data.slug + "'>" +
                                    data.username +
                                "</a>" +
                            "</div>" +
                            "<div class='message-text'>" +
                                data.message +
                            "</div>" +
                        "</div>" +
                    "</div>";

                panel.append(template);
                panel.scrollTop(panel[0].scrollHeight);
            };
            socket.onopen = function () {
                $("#chat .panel-body").append("<strong>You have connected.</strong><p></p>");
            };
            socket.onclose = function () {
                $("#chat .panel-body").append("<strong>You have disconnected.</strong><p></p>");
            };
        }
    });

    $(document).on("click", "#send-chat-input", sendMessage);
    $(document).on("keypress", "#chat-input", function (e) {
        if (e.keyCode === 13) {
            sendMessage();
        }
    });
}());
