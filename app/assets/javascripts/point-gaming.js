var PointGaming = PointGaming || {};

PointGaming = (function () {
    "use strict";

    var socket,
        handlers = {
            open: [],
            message: []
        },
        channels = {},
        state = {},
        module,

        CONNECTING = 0,
        OPEN = 1,
        CLOSING = 2,
        CLOSED = 3;

    function callHandlers(on, data) {
        handlers[on].forEach(function (fn) {
            if (typeof fn === "function") {
                fn(data);
            }
        });
    }

    function assembleSocket() {
        var url = "ws",
            timesClosed = 0;

        if (window.location.protocol.match("https")) {
            url += "s";
        }

        url += "://" + window.location.host + "/socket";

        if (socket) {
            socket.close();
        }

        socket = new ReconnectingWebSocket(url);
        socket.onopen = function () {
            var klass, channel;

// This needs to be done, unfortunately, because subscribe() will get called
// before the socket has actually opened. This also gets called when the socket
// reconnects after a random disconnect.

            for (klass in channels) {
                if (channels.hasOwnProperty(klass) && channels[klass]) {
                    channel = klass + "." + channels[klass];
                    socket.send(
                        JSON.stringify({
                            action: "subscribe",
                            channel: channel
                        })
                    );
                }
            }

            callHandlers("open");
        };
        socket.onclose = function () {
            if (timesClosed > 0) {
                PointGaming.reloadStreamTable("bets");
            }

            timesClosed += 1;
        };
        socket.onmessage = function (e) {
            var data = JSON.parse(e.data);

            if (data["class"]) {
                state[data["class"]] = data.data;
            }

            if (data.action === "refresh") {
                window.location.reload(true);
                return;
            }

            callHandlers("message", data);
        };
    }

    assembleSocket();

    module = {
        streamId: function () {
            return $("#stream-wrapper").data("stream-id");
        },

        streamUrl: function () {
            return "/streams/" + PointGaming.streamId();
        },

        reloadStreamTable: function (resource) {
            $.ajax({
                url: module.streamUrl() + "/" + resource,
                method: "GET",

                success: function (data) {
                    $("#" + resource).replaceWith(data);
                }
            });
        },

        getCurrentMatch: function () {
            return state.match;
        },

        subscribe: function (klass, id) {
            var channel = klass + "." + id,
                data = {
                    action: "subscribe",
                    channel: channel
                };

            if (channels[klass] === id) {
                return;
            }

            if (channels[klass]) {
                module.unsubscribe(klass);
            }

            channels[klass] = id;

            if (socket.readyState === OPEN) {
                socket.send(JSON.stringify(data));
            }
        },

        unsubscribe: function (klass) {
            var channel = channels[klass],
                data = {
                    action: "unsubscribe",
                    channel: channel
                };

            if (socket.readyState === OPEN) {
                socket.send(JSON.stringify(data));
            }

            channels[klass] = null;
        },

        send: function (klass, data) {
            if (!data) {
                return;
            }

            data.channel = klass + "." + channels[klass];
            socket.send(JSON.stringify(data));
        },

        disconnect: function () {
            socket.close();
        },

        on: function (on, action, handler) {
            if (typeof action === "function") {
                handler = action;
            }

            if (typeof handler === "function") {
                if (on === "message") {
                    handlers[on].push(function (data) {
                        var splitAction = action.split(":");

                        if (data.action === splitAction[0]) {
                            if (splitAction[1]) {
                                if (data["class"] === splitAction[1]) {
                                    handler(data);
                                }
                            } else {
                                handler(data);
                            }
                        }
                    });
                } else {
                    handlers[on].push(function () {
                        handler();
                    });
                }
            }
        }
    };

    return module;
}());
