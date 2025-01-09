package com.dna.meet_easy.controller;

import com.dna.meet_easy.model.Booking;
import com.dna.meet_easy.model.Room;
import com.dna.meet_easy.model.User;
import com.dna.meet_easy.repository.BookingRepository;
import com.dna.meet_easy.repository.UserRepository;

import io.swagger.v3.oas.annotations.Operation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

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

    @Operation(summary = "Get Booking by UserId", operationId = "getBookingsByUserId")
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Room>> getRoomsBookedByUser(@PathVariable Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity.notFound().build(); // 404 Not Found if user does not exist
        }

        List<Booking> bookings = bookingRepository.findByUserId(userId);
        List<Room> bookedRooms = bookings.stream()
                                          .map(Booking::getRoom) // Assuming Booking has a getRoom() method
                                          .collect(Collectors.toList());

        return ResponseEntity.ok(bookedRooms); // 200 OK with the list of booked rooms
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
