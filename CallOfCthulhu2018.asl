// Splits once loading is done because can't do a logical check for which load screen is which without entering the level first sadly
// Easiest fix compared to trying to sort through hours of finding a code for the current map as it's usually locked cause UE4 bad
state("CallOfCthulhu", "version.initial")
{
    int loading1 : 0x031351D0, 0x8;
}

state("CallOfCthulhu", "version.latest")
{
    int loading1 : 0x031351D0, 0x8;
}

startup
{
    settings.Add("initial_version", false, "Initial Game Version");
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string>
    	{
			{"1","Chapter 2: Dark Water"},
			{"2","Chapter 3: Garden of the Hawkins mansion"},
			{"3","Chapter 4: Tunnels Under the Hawkins mansion"},
			{"4","Chapter 5: Riverside Institute"},
			{"5","Chapter 6: Hawkins mansion"},
			{"6","Chapter 7: The Nameless Bookstore"},
			{"7","Chapter 8: Riverside Institute"},
			{"8","Chapter 9: Riverside Institute"},
			{"9","Chapter 10: Darkwater police station"},
			{"10","Chapter 11: Darkwater police station"},
			{"11","Chapter 12: Darkwater Port"},
			{"12","Chapter 13: Abandoned whaling station"},
			{"13","Chapter 14: Coastal Cave Alabaster Point"},
		};
		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};

    vars.onStart = (EventHandler)((s, e) =>
    {
		vars.counter = 0;
    });

    timer.OnStart += vars.onStart;

    	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Wanted: Weapons of Fate",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );

            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }
}

init
{
	vars.counter = 0; // Just so there is custimization per load, and that it doesn't decide to split within the same world
	vars.oldcomparision = 0; // Just in case you die or soft-reset it doesn't split again, comparing this to the current.loading1 per each split
}

update
{
	if ((current.loading1 != 2) && (old.loading1 == 2) && (vars.oldcomparision != current.loading1))
	{
		vars.counter++;
	}

}

start
{
    if (modules.First().ModuleMemorySize == 0x57397248)
        version = "version.initial";
    else
        version = "version.latest";

	if ((current.loading1 != 2) && (old.loading1 == 2))
	{
		vars.counter = 0;
		return true;
	}
}

split
{
    string currentMap = (vars.counter.ToString());

	if ((settings[currentMap]) && (old.loading1 != current.loading1) && (!vars.doneMaps.Contains(currentMap)))
	{
		vars.oldcomparision = current.loading1;
		return true;		
	}
}


isLoading
{
	return (current.loading1 == 2); 
}

exit 
{
    timer.OnStart -= vars.onStart;
}
