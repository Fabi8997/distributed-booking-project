-module(mnesia_manager).
-export([init/1, handle_call/3, handle_cast/2]).
-export([start_server/0, login/2, register/2, add_beach/2, get_beach/1, insert_booking/4, get_booking/1,
	get_user/1, add_subscription/4, update_subscription/2, get_subscription/1, get_user_subscription/1, all_bookings/1]).
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

%%%===================================================================
%%% BEACH OPERATIONS
%%%===================================================================

add_beach(Description, Slots) ->
	gen_server:call(mnesia_manager, {add_beach, {Description, Slots}}).

get_beach(BeachId) ->
	gen_server:call(mnesia_manager, {get_beach, BeachId}).

%%%===================================================================
%%% SUBSCRIPTION OPERATIONS
%%%===================================================================

add_subscription(BeachName, User, Type, EndDate) ->
	gen_server:call(mnesia_manager, {add_subscription, {BeachName, User, Type, EndDate}}).

update_subscription(SubId, Status) ->
	gen_server:call(mnesia_manager, {update_subscription, {SubId, Status}}).
	
get_subscription(SubId) ->
	gen_server:call(mnesia_manager, {get_subscription, SubId}).

get_user_subscription(User) -> 
	gen_server:call(mnesia_manager, {get_user_subscription, User}).


%%%===================================================================
%%% BOOKING OPERATIONS
%%%===================================================================

insert_booking(Username, BeachId, Type, Timestamp) ->
	gen_server:call(mnesia_manager, {insert_booking, {Username, BeachId, Type, Timestamp}}).

get_booking(BookingId) ->
	gen_server:call(mnesia_manager, {get_booking, BookingId}).
	
all_bookings(User) ->
	gen_server:call(mnesia_manager, {all_bookings, {User}}).

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

handle_call({register, {Username, Password, Credit}}, _From, _Status) ->
	Result = mnesia_server:register(Username,Password,Credit),
	{reply, Result, _Status };

handle_call({get_user, Username}, _From, _Status) ->
	Result = mnesia_server:get_user(Username),
	{reply, Result, _Status };

handle_call({add_beach, {Description, Slots}}, _From, _Status) ->
	Result = mnesia_server:add_beach(Description, Slots),
	{reply, Result, _Status };

handle_call({get_beach, BeachId}, _From, _Status) ->
	Result = mnesia_server:get_beach(BeachId),
	{reply, Result, _Status };

handle_call({add_subscription, {Name, Description, User}}, _From, _Status) ->
	Result = mnesia_server:add_good(Name, Description, User),
	{reply, Result, _Status };

handle_call({update_subscription, {SubId, Status}}, _From, _Status) ->
	Result = mnesia_server:update_subscription(SubId, Status),
	{reply, Result, _Status };

handle_call({get_user_subscription, User}, _From, _Status) ->
	Result = mnesia_server:get_user_subscription(User),
	{reply, Result, _Status };

handle_call({get_subscription, SubId}, _From, _Status) ->
	Result = mnesia_server:get_subscription(SubId),
	{reply, Result, _Status };
	
handle_call({insert_booking, {Username, BeachId, Type, Timestamp}}, _From, _Status) ->
	Result = mnesia_server:insert_booking(Username, BeachId, Type, Timestamp),
	{reply, Result, _Status };

handle_call({get_booking, BookingId}, _From, _Status) ->
	Result = mnesia_server:get_booking(BookingId),
	{reply, Result, _Status }.
	
handle_call({all_bookings, User}, _From, _Status) ->
	Result = mnesia_server:all_bookings(User),
	{reply, Result, _Status }.

handle_cast(reset, _Status) ->
	{
		noreply,
		[]
	}.

%%ADD terminate both here and in the other file