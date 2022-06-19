package dto;

import com.ericsson.otp.erlang.OtpErlangTuple;

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

    public UserDTO(OtpErlangTuple userInfo) {
        userId = Integer.parseInt(userInfo.elementAt(1).toString());
        username = userInfo.elementAt(2).toString();
        password = userInfo.elementAt(3).toString();
        subscribed = Boolean.parseBoolean(userInfo.elementAt(4).toString());
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

