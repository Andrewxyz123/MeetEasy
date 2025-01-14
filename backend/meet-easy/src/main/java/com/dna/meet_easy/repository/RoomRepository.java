package com.dna.meet_easy.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.dna.meet_easy.model.Room;
// import com.dna.meet_easy.model.CompanyBranch;
// import com.dna.meet_easy.model.Company;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
     @Query("SELECT r FROM Room r " +
       "JOIN CompanyBranch b ON r.branch.id = b.id " +
       "JOIN Company c ON b.company.id = c.id " +
       "WHERE c.id = :companyId")
    List<Room> findRoomsByCompanyId(@Param("companyId") Long companyId);

}
