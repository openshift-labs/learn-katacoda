Now extend the **TodoAppIT** with the new test in the editor.
```java
package org.citrus.samples;

import org.testng.annotations.Test;

import com.consol.citrus.annotations.CitrusTest;
import com.consol.citrus.dsl.testng.TestNGCitrusTestDesigner;
import com.consol.citrus.http.client.HttpClient;
import com.consol.citrus.message.MessageType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;

public class TodoAppIT extends TestNGCitrusTestDesigner {

    @Autowired
    private HttpClient todoClient;
    
    @Test
    @CitrusTest
    public void testGet() {
       http()
           .client(todoClient)
           .send()
           .get("/api/todolist/");

        http()
           .client(todoClient)
           .receive()
           .response(HttpStatus.OK);
    }
    
    @Test
    @CitrusTest
    public void testTodoLifecycle() {
        variable("todoId", "citrus:randomUUID()");
        variable("todoName", "citrus:concat('todo_', citrus:randomNumber(4))");
        variable("todoDescription", "Description: ${todoName}");
    
        http()
            .client(todoClient)
            .send()
            .post("/api/todolist")
            .messageType(MessageType.JSON)
            .contentType("application/json")
            .payload("{ \"id\": \"${todoId}\", " +
                        "\"title\": \"${todoName}\", " +
                        "\"description\": \"${todoDescription}\", " +
                        "\"done\": false}");
    
        http()
            .client(todoClient)
            .receive()
            .response(HttpStatus.OK)
            .messageType(MessageType.PLAINTEXT)
            .payload("${todoId}");
    
        http()
            .client(todoClient)
            .send()
            .get("/api/todo/${todoId}")
            .accept("application/json");
    
        http()
            .client(todoClient)
            .receive()
            .response(HttpStatus.OK)
            .messageType(MessageType.JSON)
            .validate("$.id", "${todoId}")
            .validate("$.title", "${todoName}")
            .validate("$.description", "${todoDescription}")
            .validate("$.done", false);
        
        http()
            .client(todoClient)
            .send()
            .delete("/api/todo/${todoId}")
            .accept("application/json");
        
        http()
            .client(todoClient)
            .receive()
            .response(HttpStatus.OK);
    }
}
```
[editor](/edit/replace?file=app-tests/src/test/java/org/citrus/samples/TodoAppIT.java)
[editor](/save?file=app-tests/src/test/java/org/citrus/samples/TodoAppIT.java)

## Running the suite again
Let's execute the tests again!
 
`mvn clean verify -f app-tests/pom.xml`[term](/execute)
