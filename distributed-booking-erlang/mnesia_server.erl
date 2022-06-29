%%%-------------------------------------------------------------------
%%% @author Stefano
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. apr 2022 16:55
%%%-------------------------------------------------------------------
-module(mnesia_server).

%% API
-export([init/0, login/2, register/2, all_user/0,
  add_user/3, add_subscription/4, add_beach/3, is_subscription_present/1, is_beach_present/1,
  is_user_present/1, is_user_id_present/1, start_all_counters/0, start_counter/1, all_beaches/0, all_bookings/1, all_subscriptions/1,
  get_all_counters/0, empty_all_tables/0, get_subscription/1, get_beach/1, get_user/1, is_subscription_active/2,
  update_subscription/4, get_user_subscription/1, insert_booking/4, is_booking_present/1, get_booking/1,
  delete_user/1, delete_booking/1, delete_subscription/1, update_beach/2, is_user_booking_present/4,
  is_subscription_possible/5, insert_booking_subscription/5]).

-export([]).

-export([]).

%% Slots functions
-export([insert_slots/3, all_beach_slot/1, all_beach_date_slot/2, get_available_slots/2, decrease_slots/3,
         increase_slots/3, update_slots/3]).
  %%all_beaches/1,

-include_lib("stdlib/include/qlc.hrl").
-include("headers/records.hrl").

%%%===================================================================
%%% API
%%%===================================================================
init() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  case mnesia:wait_for_tables([user, beach, booking, subscription, slot, table_id], 5000) == ok of
    true ->
      ok;
    false ->
      mnesia:create_table(user,
        [{attributes, record_info(fields, user)},
          {disc_copies, [node()]}
        ]),
      mnesia:create_table(beach,
        [{attributes, record_info(fields, beach)},
          {disc_copies, [node()]}
        ]),		
      mnesia:create_table(booking,
        [{attributes, record_info(fields, booking)},
          {type, bag},
          {disc_copies, [node()]}
        ]),
	    mnesia:create_table(subscription,
        [{attributes, record_info(fields, subscription)},
          {disc_copies, [node()]}
        ]),	
      mnesia:create_table(slot,
        [{attributes, record_info(fields, slot)},
          {disc_copies, [node()]}
        ]), 
      mnesia:create_table(table_id,
        [{attributes, record_info(fields, table_id)},
          {disc_copies, [node()]}
        ])
  end.
  
start_counter(TableName) ->
    Fun = fun() ->
      mnesia:write(table_id,
        #table_id{table_name=TableName, 
        last_id=0
      } )
          end,
    mnesia:transaction(Fun).

start_all_counters() -> 
      Fun = fun() ->
      mnesia:write(#table_id{table_name=user, 
        last_id=0
      }),
      mnesia:write(#table_id{table_name=beach, 
        last_id=0
      }),
      mnesia:write(#table_id{table_name=booking, 
        last_id=0
      }),
      mnesia:write(#table_id{table_name=slot, 
        last_id=0
      }),
	    mnesia:write(#table_id{table_name=subscription, 
        last_id=0
      })
          end,
    mnesia:activity(transaction,Fun).

  
empty_all_tables() ->
      mnesia:clear_table(user),
      mnesia:clear_table(beach),
      mnesia:clear_table(booking),
	    mnesia:clear_table(subscription),
      mnesia:clear_table(slot),
      mnesia:clear_table(table_id).

get_all_counters() ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(table_id)]),
    qlc:e(Q)
      end,
  mnesia:transaction(F).


%%%===================================================================
%%% USER OPERATIONS
%%%===================================================================

add_user(Username, Password, State) ->
  Index = mnesia:dirty_update_counter(table_id, user, 1),
  Fun = fun() ->
    mnesia:write(#user{userId = Index,
      username = Username,
      password = Password,
	  state = State
    })
        end,
  mnesia:activity(transaction, Fun).
  
register(Username, Password) ->
  F = fun() ->
    case is_user_present(Username) of
      false -> % User not present
        add_user(Username, Password, none),
        true;
      true ->
        false
    end
      end,
  mnesia:activity(transaction, F).

login(Username, Password) ->
  F = fun() ->
    case is_user_present(Username) of
      true -> % User present
        %% GET PASSWORD
        Q = qlc:q([E || E <- mnesia:table(user),E#user.username == Username]),
        [{user, _, Username, Pass, _}] = qlc:e(Q),

        %% CHECK IF THE PASSWORD IS CORRECT
        case Password =:= Pass of
          true ->
            true;
          false -> 
            false
        end;
      false ->
        false
    end
      end,
  mnesia:activity(transaction, F).


is_user_present(Username) ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(user),E#user.username == Username]),
    case qlc:e(Q) =:= [] of
      true ->
        false;
      false ->
        true
    end
      end,
   {atomic,Res} = mnesia:transaction(F),
   Res.

is_user_id_present(UserId) ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(user),E#user.userId == UserId]),
    case qlc:e(Q) =:= [] of
      true ->
        false;
      false ->
        true
    end
      end,
   {atomic,Res} = mnesia:transaction(F),
   Res.

all_user() ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(user)]),
    qlc:e(Q)
      end,
  {atomic, Res} = mnesia:transaction(F),
 Res.

get_user(Username) -> 
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(user),E#user.username == Username]),
        [User] = qlc:e(Q),
        User
  end,
  {atomic, Res} = mnesia:transaction(F),
  Res.
  
delete_user(Username) ->
  F = fun() ->
	case is_user_id_present(Username) of
		true ->
			mnesia:delete(user, Username, write);
		false ->
			false
	end
  end,
  mnesia:activity(transaction, F).

  
%%%===================================================================
%%% BEACH OPERATIONS
%%%===================================================================
  
add_beach(Name, Description, Slots) ->
  Index = mnesia:dirty_update_counter(table_id, beach, 1),
  Fun = fun() ->
    mnesia:write(#beach{beach_id = Index,
      name = Name,
      description = Description,
      slots = Slots
    })
        end,
  mnesia:activity(transaction, Fun).

%%update_auction(AuctionId, CurrentPrice, CurrentWinner) ->
%%  F = fun() ->
%%    [Auction] = mnesia:read(auction, AuctionId),
%%    mnesia:write(Auction#auction{currentWinner = CurrentWinner, currentPrice = CurrentPrice})
%%      end,
%%  mnesia:activity(transaction, F).


is_beach_present(BeachId) ->
  F = fun() ->
    case mnesia:read({beach, BeachId}) =:= [] of
      true ->
        false;
      false ->
        true
    end
  end,
  mnesia:activity(transaction, F).
  
get_beach(BeachId) ->
  F = fun() ->
    case is_beach_present(BeachId) of
      true ->
        [Beach] = mnesia:read({beach, BeachId}),
        Beach;
      false ->
        false
    end
  end,
  mnesia:activity(transaction, F).

all_beaches() ->
  F = fun() ->
   Q = qlc:q([E || E <- mnesia:table(beach)]),
   qlc:e(Q)
      end,
  {atomic, Res} = mnesia:transaction(F),
 Res.
 
update_beach(BeachId, Desc) ->
  F = fun() ->
    [Beach] = mnesia:read(beach, BeachId),
    mnesia:write(Beach#beach{description = Desc})
      end,
  mnesia:activity(transaction, F).
 
  
%%%===================================================================
%%% SUBSCRIPTION OPERATIONS
%%%===================================================================
  
add_subscription(BeachId, User, Type, EndDate) ->
  Index = mnesia:dirty_update_counter(table_id, subscription, 1),
  Fun = fun() ->
    mnesia:write(#subscription{subscription_id = Index,
	  beach_id = BeachId,
	  username = User,
	  type = Type,
	  status = active,
	  end_date = EndDate
    })
        end,
  mnesia:activity(transaction, Fun).

update_subscription(SubId, Type, Status, EndDate) ->
  F = fun() ->
    [Subscription] = mnesia:read(subscription, SubId),
    mnesia:write(Subscription#subscription{type = Type, status = Status, end_date = EndDate})
      end,
  mnesia:activity(transaction, F).

is_subscription_present(SubId) ->
  F = fun() ->
    case mnesia:read({subscription, SubId}) =:= [] of
      true ->
        false;
      false ->
        true
    end
      end,
  mnesia:activity(transaction, F).
  
is_subscription_active(Username, BeachId) ->
  F = fun() ->
	Q = qlc:q([E || E <- mnesia:table(subscription),E#subscription.username == Username, E#subscription.beach_id == BeachId, E#subscription.status == active]),
     case qlc:e(Q) =:= [] of
      true ->
        false;
      false ->
        true
    end
      end,
   {atomic,Res} = mnesia:transaction(F),
   Res.
  

get_user_subscription(User) ->
  F = fun() ->
    mnesia:match_object(subscription, {subscription,'_',User,'_','_',active,'_'}, read)  
    end,
  mnesia:activity(transaction, F).

get_subscription(SubId) ->
  F = fun() ->
    case is_subscription_present(SubId) of
      true ->
        [Subscription] = mnesia:read({subscription, SubId}),
        Subscription;
      false ->
        false
    end
  end,
  mnesia:activity(transaction, F).
  
all_subscriptions(User) ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(subscription),E#subscription.username == User]),
    qlc:e(Q)
      end,
  {atomic, Res} = mnesia:transaction(F),
  Res.
  
delete_subscription(SubId) ->
  F = fun() ->
	case is_subscription_present(SubId) of
		true ->
			mnesia:delete(subscription, SubId, write);
		false ->
			false
	end
  end,
  mnesia:activity(transaction, F).

%%%===================================================================
%%% BOOKING OPERATIONS
%%%===================================================================
insert_booking(Username, BeachId, Type, Timestamp) ->
  Index = mnesia:dirty_update_counter(table_id, booking, 1),
  Fun = fun() ->
    mnesia:write(#booking{booking_id = Index,
	  username = Username,
      beach_id = BeachId,
	  type = Type,
      timestamp = Timestamp
    })
        end,
  mnesia:activity(transaction, Fun).

is_booking_present(BookingId) ->
  F = fun() ->
    case mnesia:read({booking, BookingId}) =:= [] of
      true ->
        false;
      false ->
        true
    end
  end,
  mnesia:activity(transaction, F).


is_user_booking_present(Username, _BeachId, Type, Date) ->
  F = fun() ->
    case Type of 
      TypeValue when TypeValue =:= morning; TypeValue =:= afternoon ->
        Q = qlc:q([E || E <- mnesia:table(booking),E#booking.username == Username, E#booking.type == Type, E#booking.timestamp == Date]),
        case qlc:e(Q) =:= [] of
          true ->
            false;
          false ->
            true
        end;
      all_day ->
        Q = qlc:q([E || E <- mnesia:table(booking),E#booking.username == Username, E#booking.timestamp == Date]),
        case qlc:e(Q) =:= [] of
          true ->
            false;
          false ->
            true
        end
    end
  end,
  mnesia:activity(transaction, F).

get_booking(BookingId) ->
  F = fun() ->
    case is_booking_present(BookingId) of
      true ->
        [Booking] = mnesia:read({booking, BookingId}),
        Booking;
      false ->
        false
    end
  end,
  {atomic, Res} = mnesia:transaction(F),
  Res.
 
all_bookings(User) ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(booking),E#booking.username == User]),
    qlc:e(Q)
      end,
  {atomic, Res} = mnesia:transaction(F),
  Res.
  
 
 
delete_booking(BookingId) ->
  F = fun() ->
	case is_booking_present(BookingId) of
		true ->
			Booking = get_booking(BookingId),
			case increase_slots(element(4, Booking), element(6, Booking), element(5, Booking)) of
				true ->
					mnesia:delete(booking, BookingId, write);
				false ->
					false
			end;
		false ->
			false
	end
  end,
  mnesia:activity(transaction, F).


%%%===================================================================
%%% SLOTS OPERATIONS
%%%===================================================================

%%To be executed only one time at the creation of the database FARLO SU SERVER SPIAGGIA
insert_slots(BeachId, Date, SlotsNumber) ->
  Index = mnesia:dirty_update_counter(table_id, slot, 1),
  Fun = fun() ->
    mnesia:write(#slot{ slot_id = Index,
    beach_id = BeachId,
    date = Date,
    morning_free_slots = SlotsNumber,
    afternoon_free_slots = SlotsNumber
    })
  end,
  mnesia:activity(transaction, Fun).

all_beach_slot(BeachId) ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(slot),E#slot.beach_id == BeachId]),
    qlc:e(Q)
      end,
  {atomic, Res} = mnesia:transaction(F),
  Res.

%%Useless?
all_beach_date_slot(BeachId, Date) ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(slot),E#slot.beach_id == BeachId, E#slot.date == Date]),
    qlc:e(Q)
      end,
  {atomic, Res} = mnesia:transaction(F),
  Res.

get_available_slots(BeachId, Date) ->
  F = fun() ->
    Q = qlc:q([{E#slot.slot_id,E#slot.morning_free_slots,E#slot.afternoon_free_slots} || E <- mnesia:table(slot),E#slot.beach_id == BeachId, E#slot.date == Date]),
    Slots = qlc:e(Q),
    case Slots =:= [] of
      true ->
        false;
      false ->
        [Result] = Slots,
        Result
    end
      end,
  {atomic, Res} = mnesia:transaction(F),
  Res.

update_slots(SlotId, Type, NewSlots) ->
  F = fun() ->
    [Slots] = mnesia:read(slot, SlotId),
    case Type of
      morning -> 
        mnesia:write(Slots#slot{morning_free_slots = NewSlots});
      afternoon ->
        mnesia:write(Slots#slot{afternoon_free_slots = NewSlots})
    end
  end,
  mnesia:activity(transaction, F).


decrease_slots(BeachId, Date, Type) ->
  F = fun() ->
    Slots = get_available_slots(BeachId, Date),
    MorningSlots = element(2,Slots),
    AfternoonSlots = element(3,Slots),
    case Type of
      morning ->
        case MorningSlots > 0 of
          true ->
            update_slots(element(1,Slots), morning, MorningSlots - 1),
            true;
          false ->
            false
        end;
      afternoon ->
        case AfternoonSlots > 0 of
          true ->
            update_slots(element(1,Slots), afternoon, AfternoonSlots - 1),
            true;
          false ->
            false
        end;
      all_day ->
          case (MorningSlots > 0) and (AfternoonSlots > 0) of
          true ->
            update_slots(element(1,Slots), morning, MorningSlots - 1),
            update_slots(element(1,Slots), afternoon, AfternoonSlots - 1),
            true;
          false ->
            false
      end
    end
  end,
  {atomic, Res} = mnesia:transaction(F),
  Res.

increase_slots(BeachId, Date, Type) ->
  F = fun() ->
    Slots = get_available_slots(BeachId, Date),
    MorningSlots = element(2,Slots),
    AfternoonSlots = element(3,Slots),
    case Type of
      morning ->
        case MorningSlots > 0 of
          true ->
            update_slots(element(1,Slots), morning, MorningSlots + 1),
            true;
          false ->
            false
        end;
      afternoon ->
        case AfternoonSlots > 0 of
          true ->
            update_slots(element(1,Slots), afternoon, AfternoonSlots + 1),
            true;
          false ->
            false
        end;
      all_day ->
          case (MorningSlots > 0) and (AfternoonSlots > 0) of
          true ->
            update_slots(element(1,Slots), morning, MorningSlots + 1),
            update_slots(element(1,Slots), afternoon, AfternoonSlots + 1),
            true;
          false ->
            false
      end
    end
  end,
  {atomic, Res} = mnesia:transaction(F),
  Res.

check_decrease_slots(BeachId, Date, Type) ->
  F = fun() ->
    Slots = get_available_slots(BeachId, Date),
    case Slots of 
      false ->
        false;
      _ ->
        MorningSlots = element(2,Slots),
        AfternoonSlots = element(3,Slots),
        case Type of
          morning ->
            case MorningSlots > 0 of
              true ->
                true;
              false ->
                false
            end;
          afternoon ->
            case AfternoonSlots > 0 of
              true ->
                true;
              false ->
                false
            end;
          all_day ->
              case (MorningSlots > 0) and (AfternoonSlots > 0) of
              true ->
                true;
              false ->
                false
          end
        end
    end
  end,
  {atomic, Res} = mnesia:transaction(F),
  Res.

is_subscription_possible(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration) -> 
  F = fun() ->
    is_subscription_possible(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration, 0)
  end,
  {atomic, Res} = mnesia:transaction(F),
  Res.

is_subscription_possible(_, _, _, _, SubscriptionDuration, SubscriptionDuration) ->
  {true,""};
is_subscription_possible(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration, DaysToAdd) ->
  {DateToCheckYear, DateToCheckMonth, DateToCheckDay} = calendar:gregorian_days_to_date(calendar:date_to_gregorian_days(StartingDate) + DaysToAdd),
  DateToCheckStr = lists:flatten(io_lib:format("~4..0w-~2..0w-~2..0w",[DateToCheckYear, DateToCheckMonth, DateToCheckDay])),
  case is_user_booking_present(Username, BeachId, SubscriptionType, DateToCheckStr) of 
    true ->
      ResultStr = string:concat("Booking already present on: ",DateToCheckStr),
      {false, ResultStr};
    false ->
      case check_decrease_slots(BeachId, DateToCheckStr, SubscriptionType) of 
        true ->
          is_subscription_possible(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration, DaysToAdd + 1);
        false ->
          ResultStr = string:concat("No available slots on: ",DateToCheckStr),
          {false, ResultStr}
      end
  end.


insert_booking_subscription(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration) -> 
  F = fun() ->
    case is_subscription_possible(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration) of
      {true,""} ->
        insert_booking_subscription(Username, BeachId, SubscriptionType, StartingDate, SubscriptionDuration, 0),
        {true,""};
      {false,Msg} -> 
        {false,Msg}  
    end
  end,
  {atomic, Res} = mnesia:transaction(F),
  Res.

insert_booking_subscription(_, _, _, _, SubscriptionDuration, SubscriptionDuration) ->
  {true,""};
insert_booking_subscription(Username, BeachId, Type, StartingDate, SubscriptionDuration, DaysToAdd) ->
  {DateToAddYear, DateToAddMonth, DateToAddDay} = calendar:gregorian_days_to_date(calendar:date_to_gregorian_days(StartingDate) + DaysToAdd),
  DateToAddStr = lists:flatten(io_lib:format("~4..0w-~2..0w-~2..0w",[DateToAddYear, DateToAddMonth, DateToAddDay])),
  case decrease_slots(BeachId, DateToAddStr, Type) of
      true -> 
        insert_booking(Username, BeachId, Type, DateToAddStr),
        insert_booking_subscription(Username, BeachId, Type, StartingDate, SubscriptionDuration, DaysToAdd + 1);
      false -> 
        ResultStr = string:concat("No available slots on: ",DateToAddStr),
        {false, ResultStr}
    end.