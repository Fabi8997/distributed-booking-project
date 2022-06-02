package dto;

import com.ericsson.otp.erlang.OtpErlangTuple;

public class BeachDTO {
    int beachId;
    String description;
    int slots;

    public BeachDTO(OtpErlangTuple beach) {
        this.beachId = Integer.parseInt(beach.elementAt(1).toString());
        this.description = beach.elementAt(2).toString();
        this.slots = Integer.parseInt(beach.elementAt(3).toString());
    }

    public int getSlots() {
        return slots;
    }

    public void setSlots(int slots) {
        this.slots = slots;
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
                ", description='" + description + '\'' +
                ", slots=" + slots +
                '}';
    }
}

