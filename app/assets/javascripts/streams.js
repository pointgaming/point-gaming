$(function () {
    "use strict";

    $("#new-stream-form").validate({
        rules: {
            "stream[name]": {
                required: true,
                remote: "/streams/validate_name"
            }
        }
    });
});
