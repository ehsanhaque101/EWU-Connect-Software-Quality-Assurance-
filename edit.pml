mtype = {req_to_update_community, display_update_form , submit_information, validate_info, receive_input, target_name_unique,send_confirnation_user, database_update, send_confirmation_website, send_error}
chan toUser = [1] of {mtype,bit};
chan toWebsite = [1] of {mtype,bit};
chan toDatabase = [1] of {mtype,bit};
proctype User(chan in, out)
{
    bit sendbit, recvbit;
    
    do
    :: out ! req_to_update_community, sendbit;
    in ? display_update_form, recvbit;
    out ! submit_information, sendbit;
    out ! validate_info, sendbit;
    in ? send_error, recvbit;
    od
 
}
proctype Website(chan in, out, db)
{
    bit sendbit, recvbit;
    
    do::
    in ? req_to_update_community(recvbit);
    out ! display_update_form(sendbit);
    in ? submit_information(recvbit);
    in ? validate_info(recvbit);
    in ! target_name_unique(recvbit);
    in ? target_name_unique(recvbit);
    db ! send_confirnation_user, sendbit ->
    in ? send_confirmation_website, recvbit;
    out ! send_error(sendbit);
    
    od
 
}
proctype Database(chan in, out)
{
    bit recvbit, sendbit;
    do
    :: in ? send_confirnation_user(recvbit) ->
    out ! send_confirmation_website(recvbit);
    od
 
}
init
{
    run User(toUser, toWebsite);
    run Website(toWebsite, toUser, toDatabase);
    run Database(toDatabase, toWebsite);
}
