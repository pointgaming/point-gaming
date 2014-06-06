var PointGaming = PointGaming || {};

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
        state = {},

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

            if (data["class"]) {
                state[data["class"]] = data.data;
            }

            callHandlers("message", data);
        };
    }

    assembleSocket();

    module = {
        streamUrl: function () {
            var streamId = $("#stream-wrapper").data("stream-id");
            return "/streams/" + streamId;
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

        subscribe: function (chan) {
            var data = {
                action: "subscribe",
                channel: chan
            };

            if (channel) {
                module.unsubscribe(channel);
            }

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
