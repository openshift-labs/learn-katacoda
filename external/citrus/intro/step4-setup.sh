#!/bin/bash

touch /root/citrus-sample/src/test/java/org/citrus/samples/TodoAppLifecycleIT.java
cat > /root/citrus-sample/src/test/java/org/citrus/samples/TodoAppLifecycleIT.java << EOM
package org.citrus.samples;

import org.testng.annotations.Test;
import com.consol.citrus.annotations.CitrusTest;
import com.consol.citrus.dsl.testng.TestNGCitrusTestRunner;
import com.consol.citrus.http.client.HttpClient;
import com.consol.citrus.message.MessageType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;

public class TodoAppLifecycleIT extends TestNGCitrusTestRunner {

    @Autowired
    private HttpClient todoClient;

    @Test
    @CitrusTest
    public void testTodoLifecycle() {
        variable("todoId", "citrus:randomUUID()");
        variable("todoName", "citrus:concat('todo_', citrus:randomNumber(4))");
        variable("todoDescription", "Description: ...");
        http(http -> http
            .client(todoClient)
            .send()
            .post("/api/todolist")
            .messageType(MessageType.JSON)
            .contentType("application/json")
             .payload("{ \"id\": \"\${todoId}\", " +
                    "\"title\": \"\${todoName}\", " +
                    "\"description\": \"\${todoDescription}\", " +
                    "\"done\": false}"
            ));

        http(http -> http
            .client(todoClient)
            .receive()
            .response(HttpStatus.OK)
            .messageType(MessageType.PLAINTEXT)
            .payload(""));

        http(http -> http
            .client(todoClient)
            .send()
            .get("/api/todo/\${todoId}")
            .accept("application/json"));

        http(http -> http
            .client(todoClient)
            .receive()
            .response(HttpStatus.OK)
            .messageType(MessageType.JSON)
            .validate("$.id", "\${todoId}")
            .validate("$.title", "\${todoName}")
            .validate("$.description", "\${todoDescription}")
            .validate("$.done", false));

        http(http -> http
            .client(todoClient)
            .send()
            .delete("/api/todo/\${todoId}")
            .accept("application/json"));

        http(http -> http
            .client(todoClient)
            .receive()
            .response(HttpStatus.OK));
    }
}


EOM

clear