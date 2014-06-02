var PointGaming;

if (!PointGaming) {
    PointGaming = {};
}

PointGaming = (function () {
    "use strict";

    var socket,
        channel = "",
        handlers = {
            open: [],
            close: [],
            message: []
        },
        module,
        
        CONNECTING = 0,
        OPEN = 1,
        CLOSING = 2,
        CLOSED = 3;

    function callHandlers(on, data) {
        var handler, i, fs;

        if (handlers.hasOwnProperty(on)) {
            fs = handlers[on];

            for (i = 0; i < fs.length; i += 1) {
                if (typeof fs[i] === "function") {
                    fs[i](data);
                }
            }
        }
    }

    function assembleSocket() {
        var url = "ws";

        if (window.location.protocol.match("https")) {
            url += "s";
        }

        url += "://" + window.location.host + "/socket";

        if (socket) {
            socket.close();
        }

        socket = new WebSocket(url);
        socket.onopen = function () {
            if (channel) {
                module.subscribe(channel);
            }

            callHandlers("open");
        };
        socket.onclose = function () {
            callHandlers("close");
        };
        socket.onmessage = function (e) {
            var data = JSON.parse(e.data);
            callHandlers("message", data);
        };
    }

    assembleSocket();

    module = {
        streamUrl: function () {
            var streamId = $("#stream-wrapper").data("stream-id");
            return "/streams/" + streamId;
        },

        subscribe: function (chan) {
            var data = {
                action: "subscribe",
                channel: chan
            };

            channel = chan;

            if (socket.readyState === OPEN) {
                socket.send(JSON.stringify(data));
            }
        },

        unsubscribe: function () {
            var data = {
                action: "unsubscribe",
                channel: channel
            };

            socket.send(JSON.stringify(data));
            channel = null;
        },

        send: function (data) {
            if (!data) {
                return;
            }

            data.channel = channel;
            socket.send(JSON.stringify(data));
        },

        disconnect: function () {
            socket.close();
        },

        on: function (on, action, handler) {
            if (handlers.hasOwnProperty(on)) {
                if (typeof action === "function") {
                    handler = action;
                }

                if (typeof handler === "function") {
                    handlers[on].push(function (data) {
                        handler(data);
                    });
                }
            }
        }
    };

    return module;
}());
