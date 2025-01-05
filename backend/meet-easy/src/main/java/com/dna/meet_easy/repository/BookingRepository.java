package com.dna.meet_easy.repository;

import com.dna.meet_easy.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByRoomId(Long roomId);
    List<Booking> findByUserId(Long userId);
    
    @Query("SELECT b FROM Booking b WHERE b.room.id = :roomId AND " +
           "((b.startTime BETWEEN :startTime AND :endTime) OR " +
           "(b.endTime BETWEEN :startTime AND :endTime) OR " +
           "(b.startTime <= :startTime AND b.endTime >= :endTime))")
    List<Booking> findOverlappingBookings(Long roomId, LocalDateTime startTime, LocalDateTime endTime);
}
