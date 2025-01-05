package com.dna.meet_easy.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;
import com.dna.meet_easy.model.*;
import com.dna.meet_easy.repository.*;

@RestController
@CrossOrigin(origins = "*")
public class ApiController {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private CompanyRepository companyRepository;

    @Autowired
    private CompanyBranchRepository branchRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping("/api/roles")
    public List<Role> getAllRoles() {
        return roleRepository.findAll();
    }

    @GetMapping("/api/rooms")
    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    @GetMapping("/api/companies")
    public List<Company> getAllCompanies() {
        return companyRepository.findAll();
    }

    @GetMapping("/api/branches")
    public List<CompanyBranch> getAllBranches() {
        return branchRepository.findAll();
    }

    @GetMapping("/api/users")
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/api/bookings")
    public List<Booking> getAllBookings() {
        return bookingRepository.findAll();
    }
}
