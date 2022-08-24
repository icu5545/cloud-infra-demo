package com.hydrost.cloudinfrademo;

import java.time.Instant;

public class Message {
    
    public String getMessage() {
        return "Automate all the";
    }

    public Long getTimestamp() {
        return Instant.now().toEpochMilli();
    }
}
