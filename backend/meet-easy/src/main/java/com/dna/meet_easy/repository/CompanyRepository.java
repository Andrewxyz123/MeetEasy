package com.dna.meet_easy.repository;

import com.dna.meet_easy.model.Company;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CompanyRepository extends JpaRepository<Company, Long> {
    // Add custom query methods if needed
}
