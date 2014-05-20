$(function () {
    "use strict";

    var dispatcher = new WebSocketRails("localhost:3000/websocket"),
        streamId = $("#chat").data("stream-id"),
        channel,
        sendMessage = function () {
            var input = $("#chat-input").val(),
                data = {
                    message: input
                };

            channel.trigger("chat.new", data);

            $("#chat-input").val("");

            return false;
        };

    $("#send-chat-input").click(sendMessage);

    $("#chat-input").keypress(function (e) {
        if (e.keyCode === 13) {
            return sendMessage();
        }
    });
        
    if (streamId) {
        channel = dispatcher.subscribe("stream." + streamId);

        channel.bind("chat.new", function (message) {
            console.log(message);
        });
    }
});
