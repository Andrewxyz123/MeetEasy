package com.dna.meet_easy.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.dna.meet_easy.model.CompanyBranch;

@Repository
public interface CompanyBranchRepository extends JpaRepository<CompanyBranch, Long> {
    List<CompanyBranch> findByCompanyId(Long companyId);

    @Query("SELECT b FROM CompanyBranch b " +
           "JOIN Company c ON b.company.id = c.id " +
           "WHERE c.id = :companyId")
    List<CompanyBranch> findCompanyBranchesByCompanyId(@Param("companyId") Long companyId);
}
