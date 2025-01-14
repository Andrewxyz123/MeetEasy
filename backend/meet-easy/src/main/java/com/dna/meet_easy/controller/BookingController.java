package com.dna.meet_easy.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.dna.meet_easy.model.Booking;
import com.dna.meet_easy.model.User;
import com.dna.meet_easy.repository.BookingRepository;
import com.dna.meet_easy.repository.UserRepository;

import io.swagger.v3.oas.annotations.Operation;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<Booking> getAllBookings() {
        return bookingRepository.findAll();
    }

    // @Operation(summary = "Get Booking by UserId", operationId = "getBookingsByUserId")
    // @GetMapping("/user/{userId}")
    // public ResponseEntity<List<Room>> getRoomsBookedByUser(@PathVariable Long userId) {
    //     User user = userRepository.findById(userId).orElse(null);
    //     if (user == null) {
    //         return ResponseEntity.notFound().build(); // 404 Not Found if user does not exist
    //     }

    //     List<Booking> bookings = bookingRepository.findByUserId(userId);
    //     List<Room> bookedRooms = bookings.stream()
    //                                       .map(Booking::getRoom) // Assuming Booking has a getRoom() method
    //                                       .collect(Collectors.toList());

    //     return ResponseEntity.ok(bookedRooms); // 200 OK with the list of booked rooms
    // }

    @Operation(summary = "Get Bookings by UserId", operationId = "getBookingsByUserId")
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Booking>> getBookingsByUserId(@PathVariable Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity.notFound().build(); // 404 Not Found if user does not exist
        }

        List<Booking> bookings = bookingRepository.findByUserId(userId);

        if (bookings.isEmpty()) {
            return ResponseEntity.noContent().build(); // 204 No Content if no bookings found
        }

        return ResponseEntity.ok(bookings); // 200 OK with the list of bookings
    }

    @Operation(summary = "Create a new booking", operationId = "createBooking")
    @PostMapping("/createBooking")
    public ResponseEntity<?> createBooking(@RequestBody Booking bookingRequest) {
        try {
            if (bookingRequest.getStartTime() == null || bookingRequest.getEndTime() == null) {
                return ResponseEntity.badRequest().body("Start time and end time are required");
            }
    
            if (bookingRequest.getRoom() == null || bookingRequest.getRoom().getRoomNumber() == null || bookingRequest.getRoom().getRoomNumber().isEmpty()) {
                return ResponseEntity.badRequest().body("Room name is required");
            }
            // Ensure end time is after start time
            if (bookingRequest.getEndTime().isBefore(bookingRequest.getStartTime())) {
                return ResponseEntity.badRequest().body("End time must be after start time");
            }
    
            // Save the booking
            Booking savedBooking = bookingRepository.save(bookingRequest);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedBooking);
    
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating booking: " + e.getMessage());
        }
    }

    @Operation(summary = "Get Booking by Status and UserId", operationId = "getBookingsByStatusAndUserId")
    @GetMapping("/status/{status}/user/{userId}")
    public List<Booking> getBookingsByStatusAndUserId(@PathVariable String status, @PathVariable Long userId) {
        return bookingRepository.findByStatusAndUserId(status, userId);
    }

    @Operation(summary = "Change Booking Status", operationId = "changeBookingStatus")
    @PutMapping("/{bookingId}/status")
    public ResponseEntity<Booking> changeBookingStatus(@PathVariable Long bookingId, @RequestBody String newStatus) {
        return bookingRepository.findById(bookingId)
                .map(booking -> {
                    booking.setStatus(newStatus);
                    return ResponseEntity.ok(bookingRepository.save(booking));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @Operation(summary = "Delete Booking by ID", operationId = "deleteBookingById")
    @DeleteMapping("/{bookingId}")
    public ResponseEntity<Void> deleteBookingById(@PathVariable Long bookingId) {
        if (bookingRepository.existsById(bookingId)) {
            bookingRepository.deleteById(bookingId);
            return ResponseEntity.noContent().build(); // 204 No Content
        }
        return ResponseEntity.notFound().build(); // 404 Not Found
    }

    @Operation(summary = "Update Booking by ID", operationId = "updateBookingById")
    @PutMapping("/{bookingId}")
    public ResponseEntity<Booking> updateBookingById(@PathVariable Long bookingId, @RequestBody Booking updatedBooking) {
        Booking booking = bookingRepository.findById(bookingId).orElse(null);
        if (booking != null) {
            booking.setStartTime(updatedBooking.getStartTime());
            booking.setEndTime(updatedBooking.getEndTime());
            return ResponseEntity.ok(bookingRepository.save(booking));
        } else {
            return ResponseEntity.notFound().build(); // 404 Not Found
        }
    }

    // Get unapproved bookings for specific user
    @GetMapping("/unapproved")
    public ResponseEntity<List<Booking>> getUnapprovedBookings(@RequestParam Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            Long companyId = user.getCompany().getId(); // Assuming User has a getCompanyId() method
            List<Booking> unapprovedBookings = bookingRepository.findByStatusAndUserId("unapproved", userId);
            for (Booking booking : unapprovedBookings) {
                if (booking.getUser().getCompany().getId() != companyId) {
                    unapprovedBookings.remove(booking);
                }
            }
            return ResponseEntity.ok(unapprovedBookings);
        } else {
            return ResponseEntity.notFound().build(); // 404 Not Found
        }
    }

    // Get approved/rejected bookings
    @GetMapping("/reviewed")
    public ResponseEntity<List<Booking>> getReviewedBookings(@RequestParam Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            Long companyId = user.getCompany().getId(); // Assuming User has a getCompanyId() method
            List<Booking> reviewedBookings = bookingRepository.findByStatusInAndUserId(List.of("approved", "rejected"), userId);
            for (Booking booking : reviewedBookings) {
                if (booking.getUser().getCompany().getId() != companyId) {
                    reviewedBookings.remove(booking);
                }
            }
            return ResponseEntity.ok(reviewedBookings);
        } else {
            return ResponseEntity.notFound().build(); // 404 Not Found
        }
    }
}
