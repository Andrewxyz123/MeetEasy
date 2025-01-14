package com.dna.meet_easy.controller;

import com.dna.meet_easy.model.CompanyBranch;
import com.dna.meet_easy.repository.CompanyBranchRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/branches")
public class CompanyBranchController {

    @Autowired
    private CompanyBranchRepository branchRepository;

    @GetMapping
    public List<CompanyBranch> getAllBranches() {
        return branchRepository.findAll();
    }
}
