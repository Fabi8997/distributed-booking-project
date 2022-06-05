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
  add_user/3, add_subscription/4, add_beach/2, is_subscription_present/1, is_beach_present/1,
  is_user_present/1, start_all_counters/0, start_counter/1, all_beaches/0, all_bookings/1, all_subscriptions/1,
  get_all_counters/0, empty_all_tables/0, get_subscription/1, get_beach/1, get_user/1,
  update_subscription/4, get_user_subscription/1, insert_booking/4, is_booking_present/1, get_booking/1]).
  %%all_beaches/1,

-include_lib("stdlib/include/qlc.hrl").
-include("headers/records.hrl").

%%%===================================================================
%%% API
%%%===================================================================
init() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  case mnesia:wait_for_tables([user, auction, good, offer, table_id], 5000) == ok of
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


all_user() ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(user)]),
    qlc:e(Q)
      end,
  mnesia:transaction(F).

get_user(Username) -> 
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(user),E#user.username == Username]),
        [User] = qlc:e(Q),
        User
  end,
  {atomic, Res} = mnesia:transaction(F),
  Res.
  
%%%===================================================================
%%% BEACH OPERATIONS
%%%===================================================================
  
add_beach(Description, Slots) ->
  Index = mnesia:dirty_update_counter(table_id, beach, 1),
  Fun = fun() ->
    mnesia:write(#beach{beach_id = Index,
      description = Description,
      slots = Slots
    })
        end,
  mnesia:activity(transaction, Fun),
  Index.

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
  
%%%===================================================================
%%% SUBSCRIPTION OPERATIONS
%%%===================================================================
  
add_subscription(BeachName, User, Type, EndDate) ->
  Index = mnesia:dirty_update_counter(table_id, subscription, 1),
  Fun = fun() ->
    mnesia:write(#subscription{subscription_id = Index,
	  beach_id = BeachName,
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

get_user_subscription(User) ->
  F = fun() ->
    mnesia:match_object(subscription, {subscription,'_',User,'_','_','_','_'}, read)  
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

%%%===================================================================
%%% BOOKING OPERATIONS
%%%===================================================================
insert_booking(Username, BeachId, Type, Timestamp) ->
  Index = mnesia:dirty_update_counter(table_id, subscription, 1),
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
  mnesia:activity(transaction, F).
 
all_bookings(User) ->
  F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(booking),E#booking.username == User]),
    qlc:e(Q)
      end,
  {atomic, Res} = mnesia:transaction(F),
  Res.