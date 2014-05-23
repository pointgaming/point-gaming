$(function () {
    "use strict";

    var url,
        socket,
        template,
        channelId = $("#chat").data("channel-id"),
        sendMessage = function () {
            var input = $("#chat-input").val(),
                data = {
                    message: input
                };

            socket.send(JSON.stringify(data));

            $("#chat-input").val("");

            return false;
        };

    $("#send-chat-input").click(sendMessage);

    $("#chat-input").keypress(function (e) {
        if (e.keyCode === 13) {
            return sendMessage();
        }
    });
        
    if (channelId) {
        url = "ws://" + window.location.host + "/chat?channel_id=";

        socket = new WebSocket(url + channelId);
        socket.onmessage = function (e) {
            var data = JSON.parse(e.data);

            template = "" +
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

            $("#chat .panel-body").append(template);
        };
    }
});
