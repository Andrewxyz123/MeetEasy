package com.dna.meet_easy.repository;

import com.dna.meet_easy.model.CompanyBranch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CompanyBranchRepository extends JpaRepository<CompanyBranch, Long> {
    List<CompanyBranch> findByCompanyId(Long companyId);
}
