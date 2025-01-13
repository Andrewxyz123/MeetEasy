package com.dna.meet_easy.controller;

import com.dna.meet_easy.model.User;
import com.dna.meet_easy.repository.UserRepository;

import io.swagger.v3.oas.models.responses.ApiResponse;
import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;




@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    

    @PostMapping("/login-user")
    @ResponseBody
    public ResponseEntity<User> loginUser(@Valid @RequestBody User user){

        Optional<User> userExists = userRepository.findByCompanyloginidAndEmployeeid(user.getCompanyloginid(), user.getEmployeeid());
        String currentPassword=user.getPassword();

        if(userExists==null)
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        else if(!userExists.get().getPassword().equals(currentPassword))
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        else
            return ResponseEntity.ok(userExists.get());       
    }
    
    
}
