var container = require('rhea');

container.once('connection_open', function (context) {
    context.connection.open_receiver('example');
    context.connection.open_sender('example');
});

container.on('message', function (context) {
    console.log('Message received: ' + context.message.body);
});

var counter = 0;

container.once('sendable', function (context) {
    function send() {
        if (context.sender.sendable()) {
            context.sender.send({body: JSON.stringify(
                { 
                    id: ++counter, 
                    text: 'Hello World!',
                    timestamp: Date.now()
                }
            )});
        }
        setTimeout(send, 10000);
    }
    send();
});

container.on('disconnected', function (context) {
    console.log('disconnected');
});

container.connect({'host':'broker-amqp-0-svc','port':5672, 'reconnect':true});