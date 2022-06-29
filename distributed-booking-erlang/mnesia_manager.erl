-module(mnesia_manager).
-export([init/1, handle_call/3, handle_cast/2]).
-export([start_server/0, login/2, register/2, add_beach/3, get_beach/1, insert_booking/4, get_booking/1, 
	get_user/1, add_subscription/4, update_subscription/4, get_subscription/1, get_user_subscription/1,
	all_bookings/1, all_subscriptions/1, delete_user/1, delete_booking/1, delete_subscription/1, update_beach/2,
	decrease_slots/3, increase_slots/3, is_user_booking_present/4, insert_slots/3, get_available_slots/2, all_user/0,
	all_beaches/0, is_subscription_possible/5, insert_booking_subscription/5]).
-behavior(gen_server).

%%%===================================================================
%%% API
%%%===================================================================

%%%===================================================================
%%% START SERVER
%%%===================================================================

start_server() ->
	mnesia_server:init(),
	gen_server:start_link({local,mnesia_manager},?MODULE, [], []).

%%%===================================================================
%%% USER OPERATIONS
%%%===================================================================

login(Username, Password) ->
	gen_server:call(mnesia_manager, {login, {Username, Password}}).

register(Username, Password) ->
	gen_server:call(mnesia_manager, {register, {Username, Password}}).

get_user(Username) ->
	gen_server:call(mnesia_manager, {get_user, Username}).
	
delete_user(Username) ->
	gen_server:call(mnesia_manager, {delete_user, Username}).
	
all_user() ->
	gen_server:call(mnesia_manager, all_user).

%%%===================================================================
%%% BEACH OPERATIONS
%%%===================================================================

add_beach(Name, Description, Slots) ->
	gen_server:call(mnesia_manager, {add_beach, {Name, Description, Slots}}).

get_beach(BeachId) ->
	gen_server:call(mnesia_manager, {get_beach, BeachId}).
	
update_beach(BeachId, Description) ->
	gen_server:call(mnesia_manager, {update_beach, {BeachId, Description}}).
	
all_beaches() ->
	gen_server:call(mnesia_manager, all_beaches).

%%%===================================================================
%%% SUBSCRIPTION OPERATIONS
%%%===================================================================

add_subscription(BeachName, User, Type, EndDate) ->
	gen_server:call(mnesia_manager, {add_subscription, {BeachName, User, Type, EndDate}}).

update_subscription(SubId, Type, Status, EndDate) ->
	gen_server:call(mnesia_manager, {update_subscription, {SubId, Type, Status, EndDate}}).
	
get_subscription(SubId) ->
	gen_server:call(mnesia_manager, {get_subscription, SubId}).

get_user_subscription(User) -> 
	gen_server:call(mnesia_manager, {get_user_subscription, User}).
	
delete_subscription(SubId) ->
	gen_server:call(mnesia_manager, {delete_subscription, SubId}).
	
all_subscriptions(User) -> 
	gen_server:call(mnesia_manager, {all_subscriptions, User}).

is_subscription_possible(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration) ->
	gen_server:call(mnesia_manager, {is_subscription_possible, {Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration}}).

insert_booking_subscription(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration) -> 
	gen_server:call(mnesia_manager, {insert_booking_subscription, {Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration}}).

%%%===================================================================
%%% BOOKING OPERATIONS
%%%===================================================================

insert_booking(Username, BeachId, Type, Timestamp) ->
	gen_server:call(mnesia_manager, {insert_booking, {Username, BeachId, Type, Timestamp}}).

get_booking(BookingId) ->
	gen_server:call(mnesia_manager, {get_booking, BookingId}).
	
delete_booking(BookingId) ->
	gen_server:call(mnesia_manager, {delete_booking, BookingId}).
	
all_bookings(User) ->
	gen_server:call(mnesia_manager, {all_bookings, User}).

is_user_booking_present(Username, BeachId, Type, Date) ->
	gen_server:call(mnesia_manager, {is_user_booking_present, {Username, BeachId, Type, Date}}).

%%%===================================================================
%%% SLOT OPERATIONS
%%%===================================================================

insert_slots(BeachId, Date, SlotsNumber) ->
	gen_server:call(mnesia_manager, {insert_slots, {BeachId, Date, SlotsNumber}}).

decrease_slots(BeachId, Date, Type) ->
	gen_server:call(mnesia_manager, {decrease_slots, {BeachId, Date, Type}}).

increase_slots(BeachId, Date, Type) ->
	gen_server:call(mnesia_manager, {increase_slots, {BeachId, Date, Type}}).

get_available_slots(BeachId, Date) -> 
	gen_server:call(mnesia_manager, {get_available_slots, {BeachId, Date}}).

%%%===================================================================
%%% CALLBACK FUNCTIONS
%%%===================================================================

init(_InitialState) ->
  	{
  		ok,
  		[]
  	}.


handle_call({login, {Username, Password}}, _From, _Status) ->
	Result = mnesia_server:login(Username,Password),
	{reply, Result, _Status };

handle_call({register, {Username, Password}}, _From, _Status) ->
	Result = mnesia_server:register(Username,Password),
	{reply, Result, _Status };

handle_call({get_user, Username}, _From, _Status) ->
	Result = mnesia_server:get_user(Username),
	{reply, Result, _Status };
	
handle_call({delete_user, Username}, _From, _Status) ->
	Result = mnesia_server:delete_user(Username),
	{reply, Result, _Status };
	
handle_call(all_user, _From, _Status) ->
	Result = mnesia_server:all_user(),
	{reply, Result, _Status };

handle_call({add_beach, {Name, Description, Slots}}, _From, _Status) ->
	Result = mnesia_server:add_beach(Name, Description, Slots),
	{reply, Result, _Status };

handle_call({get_beach, BeachId}, _From, _Status) ->
	Result = mnesia_server:get_beach(BeachId),
	{reply, Result, _Status };
	
handle_call(all_beaches, _From, _Status) ->
	Result = mnesia_server:all_beaches(),
	{reply, Result, _Status };

handle_call({update_beach, {BeachId, Description}}, _From, _Status) ->
	Result = mnesia_server:update_beach(BeachId, Description),
	{reply, Result, _Status };

handle_call({add_subscription, {BeachId, User, Type, EndDate}}, _From, _Status) ->
	Result = mnesia_server:add_subscription(BeachId, User, Type, EndDate),
	{reply, Result, _Status };

handle_call({update_subscription, {SubId, Type, Status, EndDate}}, _From, _Status) ->
	Result = mnesia_server:update_subscription(SubId, Type, Status, EndDate),
	{reply, Result, _Status };

handle_call({get_user_subscription, User}, _From, _Status) ->
	Result = mnesia_server:get_user_subscription(User),
	{reply, Result, _Status };

handle_call({get_subscription, SubId}, _From, _Status) ->
	Result = mnesia_server:get_subscription(SubId),
	{reply, Result, _Status };
	
handle_call({delete_subscription, SubId}, _From, _Status) ->
	Result = mnesia_server:delete_subscription(SubId),
	{reply, Result, _Status };

handle_call({all_subscriptions, User}, _From, _Status) ->
	Result = mnesia_server:all_subscriptions(User),
	{reply, Result, _Status };

handle_call({is_subscription_possible, {Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration}}, _From, _Status) ->
	Result = mnesia_server:is_subscription_possible(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration),
	{reply, Result, _Status };

handle_call({insert_booking_subscription, {Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration}}, _From, _Status) ->
	Result = mnesia_server:insert_booking_subscription(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration),
	{reply, Result, _Status };
	
handle_call({insert_booking, {Username, BeachId, Type, Timestamp}}, _From, _Status) ->
	Result = mnesia_server:insert_booking(Username, BeachId, Type, Timestamp),
	{reply, Result, _Status };

handle_call({get_booking, BookingId}, _From, _Status) ->
	Result = mnesia_server:get_booking(BookingId),
	{reply, Result, _Status };
	
handle_call({delete_booking, BookingId}, _From, _Status) ->
	Result = mnesia_server:delete_booking(BookingId),
	{reply, Result, _Status };
	
handle_call({all_bookings, User}, _From, _Status) ->
	Result = mnesia_server:all_bookings(User),
	{reply, Result, _Status };

handle_call({is_user_booking_present, {Username, BeachId, Type, Date}}, _From, _Status) ->
	Result = mnesia_server:is_user_booking_present(Username, BeachId, Type, Date),
	{reply, Result, _Status };

handle_call({insert_slots, {BeachId, Date, SlotsNumber}}, _From, _Status) ->
	Result = mnesia_server:insert_slots(BeachId, Date, SlotsNumber),
	{reply, Result, _Status };

handle_call({decrease_slots, {BeachId, Date, Type}}, _From, _Status) ->
	Result = mnesia_server:decrease_slots(BeachId, Date, Type),
	{reply, Result, _Status };

handle_call({increase_slots, {BeachId, Date, Type}}, _From, _Status) ->
	Result = mnesia_server:increase_slots(BeachId, Date, Type),
	{reply, Result, _Status };

handle_call({get_available_slots, {BeachId, Date}}, _From, _Status) ->
	Result = mnesia_server:get_available_slots(BeachId, Date),
	{reply, Result, _Status }.


handle_cast(reset, _Status) ->
	{
		noreply,
		[]
	}.

%%ADD terminate both here and in the other file