package it.unipi.dii.dsmt.dto;

public class UserDTO {
    Integer userId;
    String username;
    String password;
    boolean subscribed;

    public UserDTO(Integer userId, String username, String password, Boolean subscribed) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.subscribed = subscribed;
    }

    public UserDTO(Integer userId, String username) {
        this.userId = userId;
        this.username = username;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean getSubscribed() {
        return subscribed;
    }

    public void setSubscribed(Boolean subscribed) {
        this.subscribed = subscribed;
    }
}

