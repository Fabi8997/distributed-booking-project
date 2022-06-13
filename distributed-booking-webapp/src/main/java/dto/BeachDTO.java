package dto;

import com.ericsson.otp.erlang.OtpErlangTuple;

public class BeachDTO {
    int beachId;
    String name;
    String description;

    public BeachDTO(OtpErlangTuple beach) {
        this.beachId = Integer.parseInt(beach.elementAt(1).toString());
        this.name = beach.elementAt(2).toString().replace("\"", "");
        this.description = beach.elementAt(3).toString().replace("\"", "");
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public int getBeachId() {
        return beachId;
    }

    @Override
    public String toString() {
        return "BeachDTO{" +
                "beachId=" + beachId +
                ", name=" + name +
                ", description=" + description +
                '}';
    }
}

