package com.dna.meet_easy.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.dna.meet_easy.model.Room;
import com.dna.meet_easy.repository.RoomRepository;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    @Autowired
    private RoomRepository roomRepository;


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