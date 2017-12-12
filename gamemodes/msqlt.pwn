stock SelectSuspect()
{
    printf("D3");
    new R = 0;
    for(new i=0;i<MAX_PLAYERS;i++)
    {
        if(IsPlayerInCopChase[i] == true)
        {
            PlayerRole[i] = random(7);
        }
        if(PlayerRole[i] == 1)
        {
            R++;
        }
    }
    if(R == 0) return SelectSuspect();
    else return 1;
}