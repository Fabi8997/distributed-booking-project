var ws;

function connect() {
    const host = document.location.host;
    const pathname = document.location.pathname;
    const url = "ws://" +host  + pathname;
    ws = new WebSocket(url);
    console.log("Connected to " + url);

    ws.onmessage = function(event) {
        const log = document.getElementById("log");
        //console.log(event.data);
        const message = JSON.parse(event.data);
        log.innerHTML += message.from + " : " + message.morningSlots + "," + message.afternoonSlots+"\n";
        const idBeach = message.idBeach;
        let beachRow = document.getElementById("beach"+idBeach);
        let morningsSlots = beachRow.getElementsByClassName("FreeSlotsMorning");
        let afternoonSlots = beachRow.getElementsByClassName("FreeSlotsAfternoon");


        if(!(morningsSlots[0] === undefined)){
            if(message.morningSlots === 0){
                morningsSlots[0].classList.add("Full");
                morningsSlots[0].classList.remove("FreeSlotsMorning");
                morningsSlots[0].innerHTML = "Full";
            }else{
                morningsSlots[0].innerHTML = message.morningSlots;
            }
        }
        if(!(afternoonSlots[0] === undefined)){
            if(message.afternoonSlots === 0){
                afternoonSlots[0].classList.add("Full");
                afternoonSlots[0].classList.remove("FreeSlotsAfternoon");
                afternoonSlots[0].innerHTML = "Full";
            }else{
                afternoonSlots[0].innerHTML = message.afternoonSlots;
            }
        }
    };
}

function send(idBeach) {
    let json = JSON.stringify({
        "idBeach": idBeach,
        "content": "reload_slots"
    });

    ws.send(json);
}