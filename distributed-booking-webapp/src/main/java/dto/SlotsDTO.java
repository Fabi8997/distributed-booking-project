package dto;

import com.ericsson.otp.erlang.OtpErlangTuple;

public class SlotsDTO{
    private int slotId;
    private final int morningSlots;
    private final int afternoonSlots;

    public SlotsDTO(OtpErlangTuple slotsInfo) {
        slotId = Integer.parseInt(slotsInfo.elementAt(0).toString());
        morningSlots = Integer.parseInt(slotsInfo.elementAt(1).toString());
        afternoonSlots = Integer.parseInt(slotsInfo.elementAt(2).toString());
    }

    //Only for tests
    public SlotsDTO(int morningSlots, int afternoonSlots) {
        this.morningSlots = morningSlots;
        this.afternoonSlots = afternoonSlots;
    }

    public int getSlotId() {
        return slotId;
    }

    public int getMorningSlots() {
        return morningSlots;
    }

    public int getAfternoonSlots() {
        return afternoonSlots;
    }

    @Override
    public String toString() {
        return "SlotsDTO{" +
                "slotId=" + slotId +
                ", morningSlots=" + morningSlots +
                ", afternoonSlots=" + afternoonSlots +
                '}';
    }
}

