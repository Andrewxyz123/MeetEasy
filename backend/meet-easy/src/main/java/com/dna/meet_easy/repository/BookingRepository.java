package com.dna.meet_easy.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.dna.meet_easy.model.Booking;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {

    List<Booking> findByRoomId(Long roomId);

    List<Booking> findByUserId(Long userId);

    @Query("SELECT b FROM Booking b WHERE b.room.id = :roomId AND "
            + "((b.startTime BETWEEN :startTime AND :endTime) OR "
            + "(b.endTime BETWEEN :startTime AND :endTime) OR "
            + "(b.startTime <= :startTime AND b.endTime >= :endTime))")
    List<Booking> findOverlappingBookings(Long roomId, LocalDateTime startTime, LocalDateTime endTime);

    List<Booking> findByStatusAndUserId(String status, Long userId);

    List<Booking> findByStatusInAndUserId(List<String> of, Long userId);

    List<Booking> findByRoom_Branch_Id(Long branchId);

    List<Booking> findByUser_Company_Id(Long companyId);

    // @Query("SELECT b FROM Booking b WHERE b.user.id = :userId AND b.startDate > :currentDate")
    // List<Booking> findFutureBookingsByUserId(@Param("userId") Long userId, @Param("currentDate") LocalDateTime currentDate);
}
