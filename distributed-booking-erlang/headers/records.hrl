-record(booking, {booking_id,
			   username,
               beach_id,
			   type,
               timestamp
              }).

-record(subscription, {subscription_id,
			   username,
               beach_id,
			   type,
			   status,
               end_date
              }).

-record(user, {userId,
				  username,
                  password,
				  state
                }).
				
-record(beach, {beach_id,
				  name,
                  description,
				  slots
                }).

-record(slot, {slot_id,
				beach_id,
				date,
				morning_free_slots,
				afternoon_free_slots
				}).


-record(table_id, {table_name,
					last_id
				  }).
				