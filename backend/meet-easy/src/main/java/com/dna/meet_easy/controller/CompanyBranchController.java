package com.dna.meet_easy.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dna.meet_easy.model.CompanyBranch;
import com.dna.meet_easy.model.User;
import com.dna.meet_easy.repository.CompanyBranchRepository;
import com.dna.meet_easy.repository.UserRepository;

import io.swagger.v3.oas.annotations.Operation;

@RestController
@RequestMapping("/api/branches")
public class CompanyBranchController {

    @Autowired
    private CompanyBranchRepository companyBranchRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<CompanyBranch> getAllBranches() {
        return companyBranchRepository.findAll();
    }

    @Operation(summary = "Get company branches by user ID", operationId = "getCompanyBranchesByUserId")
    @GetMapping("/users/{userId}")
    public ResponseEntity<?> getCompanyBranchesByUserId(@PathVariable Long userId) {
        // Fetch the user by userId
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found.");
        }

        User user = userOptional.get();

        // Ensure the user is associated with a company
        if (user.getCompany() == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("User is not associated with a company.");
        }

        Long companyId = user.getCompany().getId(); // Get the company ID from the user

        // Use the repository instance to call the method
        
        List<CompanyBranch> companyBranches = companyBranchRepository.findCompanyBranchesByCompanyId(companyId);

        // If no branches are found, return an empty list
        if (companyBranches.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body("No branches found for this company.");
        }

        return ResponseEntity.ok(companyBranches);
    }
}
