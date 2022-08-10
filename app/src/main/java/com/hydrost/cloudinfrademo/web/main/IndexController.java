package com.hydrost.cloudinfrademo.web.main;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hydrost.cloudinfrademo.Message;

@RestController()
public class IndexController {
    
    @GetMapping("/")
    public Message index() {
        return new Message();
    }
}
