-module(booking_manager).
-export([init/1, handle_call/3, handle_cast/2]).
-export([new_booking/4, start_server/0, reset/0, initialize_slots/0, get_bookings/1, new_subscription/5, remove_subscription/6]).
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

get_bookings(Username) ->
 	gen_server:call(booking_manager, {get_bookings, Username}).

new_subscription(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration) ->
	gen_server:call(booking_manager, {new_subscription, {Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration}}).
	
remove_subscription(SubscriptionId, Username, BeachId, SubscriptionType, EndDate, SubscriptionDuration) ->
	gen_server:call(booking_manager, {remove_subscription, {SubscriptionId, Username, BeachId, SubscriptionType, EndDate, SubscriptionDuration}}).
	

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


handle_call({new_subscription, {Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration}}, _From, _Status) ->

	case mnesia_manager:insert_booking_subscription(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration) of 
		{true,_} -> 
			{EndDateYear, EndDateMonth, EndDateDay} = calendar:gregorian_days_to_date(calendar:date_to_gregorian_days(StartingDate) + SubscriptionDuration - 1),
  			EndDateStr = lists:flatten(io_lib:format("~4..0w-~2..0w-~2..0w",[EndDateYear, EndDateMonth, EndDateDay])),
			mnesia_manager:add_subscription(BeachId, Username, SubscriptionType, EndDateStr, SubscriptionDuration),
			{ reply, {true,""}, _Status };
		{false, Result}  ->
			{ reply, {false, Result}, _Status }
	end;
	
handle_call({remove_subscription, {SubscriptionId, Username, BeachId, SubscriptionType, EndDate, SubscriptionDuration}}, _From, _Status) ->

	case mnesia_manager:delete_booking_subscription(SubscriptionId, Username, BeachId, SubscriptionType, EndDate, SubscriptionDuration) of 
		{true,_} -> 
			mnesia_manager:delete_subscription(SubscriptionId),
			{ reply, {true,""}, _Status };
		{false, Result}  ->
			{ reply, {false, Result}, _Status }
	end;

handle_call({get_bookings, Username}, _From, _Status) ->
	Result = mnesia_manager:all_bookings(Username),
	{ reply, Result, _Status };

handle_call(initialize_slots, _From, _Status) ->
	{CurrentDate, _} = calendar:now_to_datetime(erlang:timestamp()),
	Result = init_slots(CurrentDate, 75),
	{ reply, Result, _Status }.


handle_cast(reset, _Status) ->
	{
		noreply,
		[]
	}.


init_slots(_,0) ->
	ok;
init_slots(StartingDate, DaysToInit) ->
	{DateToInitYear, DateToInitMonth, DateToInitDay} = calendar:gregorian_days_to_date(calendar:date_to_gregorian_days(StartingDate) + DaysToInit),
	DateToInitStr = lists:flatten(io_lib:format("~4..0w-~2..0w-~2..0w",[DateToInitYear, DateToInitMonth, DateToInitDay])),
	mnesia_manager:insert_slots(1,DateToInitStr,1000),
	mnesia_manager:insert_slots(2,DateToInitStr,250),
	mnesia_manager:insert_slots(3,DateToInitStr,1500),
	init_slots(StartingDate, DaysToInit - 1).