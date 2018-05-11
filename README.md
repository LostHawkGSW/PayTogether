# PayTogether
Pay for any contract, together!

- Allow a user to start a group payment for a contract
- User can set minimum/maximum number of members
- User can set whether or not the resulting contract will return the 'result' back to one person or everyone (multi-beneficiary)
- User can set how many users are 'guarnteed' -- this will help set expectations when inviting new users on how much they will be committing to paying
- contract will have a set amount of time before it ends successfully or fails
- contract can end before the end date if it is canceled or successfully meets the parameters of the group payment
- if contract fails or user backs out successfully they can have their funds returned
- as new members join, the cost can go down, and a member can have their extra funds returned

Available functions:
- join 
  - allow anyone to join the group payment
  - as people join the current cost per person should go down, unless someone is covering for someone who has left
- request_to_leave 
  - make a request to the rest of the group to leave, anybody can pickup the cost for that person leaving; which will be covered by following people joining or not
- plus_one
  - cover costs for someone else to stay/join
- cover
  - cover cost for someone leaving (guarntee to others the num of people wont change)
- cancel_request_to_leave
- reject_request_to_leave (admin only)
- accept_request_to_leave
- end_early (successfuly only if min params are met)
- withdraw_return_funds
- change_admin (admin only)
- current_cost_per_next_person (return the current cost for the next person to join -- this will be the cost over the currently locked in users plus one; or a set price if this is a multi-beneficiary transaction)
- current_cost_per_person
