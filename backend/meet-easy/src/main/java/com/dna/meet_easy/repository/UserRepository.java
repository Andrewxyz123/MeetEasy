package com.dna.meet_easy.repository;

import com.dna.meet_easy.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByCompanyloginidAndEmployeeid(String companyLoginId, String employeeId);
    List<User> findByCompanyId(Long companyId);
    boolean existsByCompanyloginidAndEmployeeid(String companyLoginId, String employeeId);
}
