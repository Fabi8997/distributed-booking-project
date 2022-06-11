-module(booking_manager).
-export([init/1, handle_call/3, handle_cast/2]).
-export([new_booking/4, start_server/0, reset/0]).
-behavior(gen_server).

%%API

start_server() ->
	gen_server:start_link({local,booking_manager},?MODULE, [], []).


reset() ->
	gen_server:cast(booking_manager, reset).

initialize_slots() -> 
	gen_server:call(booking_manager, initialize_slots).

new_booking(Username, BeachId, Type, Date) ->
	gen_server:call(booking_manager, {new_booking, {Username, BeachId, Type, Date}}).

%%CALLBACK

init(_InitialState) ->
  	{
  		ok,
  		[]
  	}.


handle_call({new_booking, {Username, BeachId, Type, Date}}, _From, _Status) ->

	case mnesia_manager:is_user_booking_present(Username, BeachId, Type, Date) of
		false -> 
		case mnesia_manager:decrease_slots(BeachId, Date, Type) of
			true -> 
				mnesia_manager:insert_booking(Username, BeachId, Type, Date),
				{ reply, {true, ""}, _Status };
			false -> 
				{ reply, {false, "No available slots"}, _Status }
		end;
		true->
			{ reply, {false, "Booking already present"}, _Status }
	end;



handle_call({new_booking, initialize_slots}, _From, _Status) ->
	{ reply, {true, ""}, _Status }.


handle_cast(reset, _Status) ->
	{
		noreply,
		[]
	}.

