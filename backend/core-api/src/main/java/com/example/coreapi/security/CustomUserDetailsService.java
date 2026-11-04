
package com.example.coreapi.security;

import com.example.coreapi.user.User;
import com.example.coreapi.user.UserRepository;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;
import java.util.UUID;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public CustomUserDetails loadUserByUsername(String email) {

        User user = userRepository.findByEmail(email)
                .orElseThrow(() ->
                        new UsernameNotFoundException("User not found")
                );

        return mapToUserDetails(user);
    }

    public CustomUserDetails loadUserById(UUID id) {

        User user = userRepository.findById(id)
                .orElseThrow(() ->
                        new UsernameNotFoundException("User not found")
                );

        return mapToUserDetails(user);
    }

    private CustomUserDetails mapToUserDetails(User user) {

        String role = user.getRole()
                .trim()
                .toUpperCase(Locale.ROOT);

        String authority = role.startsWith("ROLE_")
                ? role
                : "ROLE_" + role;

        return new CustomUserDetails(
                user.getId(),
                user.getEmail(),
                user.getPasswordHash(),
                List.of(new SimpleGrantedAuthority(authority)),
                Boolean.TRUE.equals(user.getIsActive())
        );
    }
}
