mtype = {req_to_create_new_community, display_community_form, submit_information, error_message, tagname_count, query_information, execute_query,redirect_to_community, allow_access, tagname_count_not_unique, receive_querry, website_login, ok, deny_access};

chan toUser = [1] of {mtype,bit};
chan toWebsite = [1] of {mtype,bit};
chan toDatabase = [1] of {mtype,bit};
bool success = 1;
proctype User(chan in, out)
{
    bit sendbit, recvbit;
    do
    :: out ! req_to_create_new_community, sendbit;
    in ?  redirect_to_community, recvbit;
    if
    :: recvbit == 1 -> in ? submit_information, recvbit ->
        out ! display_community_form, sendbit;
    :: recvbit == 0 -> in ? tagname_count_not_unique, recvbit ->
        out ! error_message, sendbit;
    fi
    od
}
proctype Website(chan in, out, db)
{
    bit sendbit, recvbit;
    do::
    in ? req_to_create_new_community(recvbit);
    db ! query_information, sendbit ->
    in ? receive_querry, recvbit;
    in ? ok, recvbit ->
    db ! execute_query, sendbit;
    if
    :: sendbit == 0 ->
    sendbit = 1; out !  redirect_to_community(sendbit);
    :: sendbit == 1 ->
    sendbit = 0; out !  redirect_to_community(sendbit);
    fi
    if

    :: sendbit == 1 -> out ! submit_information(sendbit) ->
    in ? display_community_form(recvbit);
    :: sendbit == 0 -> out ! tagname_count_not_unique(sendbit) ->
    in ? error_message(recvbit);
    fi
    od
}
proctype Database(chan in, out)
{
    bit recvbit, sendbit;
    do::
    in ? query_information(recvbit) ->
    out ! receive_querry(recvbit);
    in ! website_login(recvbit);
    in ? website_login(recvbit);
    out ! ok(recvbit) ->
    in ? execute_query(recvbit);
    od
}
init
{
    run User(toUser, toWebsite);
    run Website(toWebsite, toUser, toDatabase);
    run Database(toDatabase, toWebsite);
}
