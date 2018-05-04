var container = require('rhea');

container.on('connection_open', function (context) {
    context.connection.open_receiver('example');
    context.connection.open_sender('example');
});

container.on('message', function (context) {
    console.log('Message received: ' + context.message.body);
});

container.on('sendable', function (context) {
    function send() {
        if (context.sender.sendable()) {
            context.sender.send({body:'Hello World!'});
        }
        setTimeout(send, 10000);
    }
    send();
});

container.on('disconnected', function (context) {
    console.log('disconnected');
});

container.connect({'host':'broker-amq-amqp','port':5672, 'reconnect':true});