#if defined _realtime_included
	#endinput
#endif

#if !defined HTTP
	native HTTP(index, type, url[], data[], callback[]);
#endif

#include <sscanf2>

#define _realtime_included
#pragma library realtime

forward GetRealTime(hour, minute);

stock UpdateTime()
{
	return HTTP(0, 1, "deviceblack.ga/realtime.php", "", "OnTimeUpdate");
}

forward OnTimeUpdate(index, response, data[]);
public OnTimeUpdate(index, response, data[])
{
	if(response == 200)
	{
		new hour[2], minute[2];
		sscanf(data, "ii", hour, minute);
		CallLocalFunction("GetRealTime", "ii", hour, minute);
	}
	return 1;
}







