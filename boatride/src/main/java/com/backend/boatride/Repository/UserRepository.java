package com.backend.boatride.Repository;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.backend.boatride.Entities.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>{
    @Query("SELECT u FROM User u WHERE u.userEmail = :user_email OR u.userName = :user_name")
    Optional<User> findByUserEmailAndUserName(String user_email, String user_name);
}
