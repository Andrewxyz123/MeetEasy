package com.dna.meet_easy.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dna.meet_easy.model.Room;
import com.dna.meet_easy.model.User;
import com.dna.meet_easy.repository.RoomRepository;
import com.dna.meet_easy.repository.UserRepository;

import io.swagger.v3.oas.annotations.Operation;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private UserRepository userRepository; // Properly inject UserRepository

    @GetMapping
    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    @Operation(summary = "Get rooms by user ID", operationId = "getRoomsByUserId")
    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getRoomsByUserId(@PathVariable Long userId) {
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

        // Use the custom query to find rooms by company ID
        List<Room> rooms = roomRepository.findRoomsByCompanyId(companyId);
        return ResponseEntity.ok(rooms);
    }

    @Operation(summary = "Delete Room by ID", operationId = "deleteRoomById")
    @DeleteMapping("/{roomId}")
    public ResponseEntity<Void> deleteRoomById(@PathVariable Long roomId) {
        if (roomRepository.existsById(roomId)) {
            roomRepository.deleteById(roomId);
            return ResponseEntity.noContent().build(); // 204 No Content
        } else {
            return ResponseEntity.notFound().build(); // 404 Not Found
        }
    }

    @Operation(summary = "Update Room by ID", operationId = "updateRoomById")
    @PutMapping("/{roomId}")
    public ResponseEntity<Room> updateRoomById(@PathVariable Long roomId, @RequestBody Room updatedRoom) {
        return roomRepository.findById(roomId)
                .map(room -> {
                    room.setCapacity(updatedRoom.getCapacity());
                    room.setDescription(updatedRoom.getDescription());
                    room.setFeatures(updatedRoom.getFeatures());
                    room.setRoomNumber(updatedRoom.getRoomNumber());
                    room.setRoomType(updatedRoom.getRoomType());
                    room.setStatus(updatedRoom.getStatus());
                    return ResponseEntity.ok(roomRepository.save(room));
                })
                .orElse(ResponseEntity.notFound().build()); // 404 Not Found
    }
}
