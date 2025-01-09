package com.dna.meet_easy.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dna.meet_easy.model.Room;
import org.springframework.stereotype.Repository;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
}
