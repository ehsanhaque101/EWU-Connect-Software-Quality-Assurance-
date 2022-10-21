mtype = {request_edit_profile, display_update_form , submit_information, query_information,ok_user, ok_db}
chan toUser = [1] of {mtype,bit}
chan toWebsite = [1] of {mtype,bit};
chan toDatabase = [1] of {mtype,bit};
proctype User(chan in, out)
{
    bit sendbit, recvbit;
    
    do
    :: out ! request_edit_profile, sendbit;
    in ? display_update_form, recvbit;
    out ! submit_information, sendbit;
  
 
    od
 
}
proctype Website(chan in, out, db)
{
    bit sendbit, recvbit;
    
    do::
    in ? request_edit_profile(recvbit);
    out ! display_update_form(sendbit);
    in ? submit_information(recvbit);
    
    db ! ok_user, sendbit ->
    in ? ok_db, recvbit;
    
    
    od
 
}
proctype Database(chan in, out)
{
    bit recvbit, sendbit;
    do
    :: in ? ok_user(recvbit) ->
    out ! ok_db(recvbit);
    od
 
}
init
{
    run User(toUser, toWebsite);
    run Website(toWebsite, toUser, toDatabase);
    run Database(toDatabase, toWebsite);
}
