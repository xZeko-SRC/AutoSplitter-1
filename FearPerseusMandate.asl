state("FEARXP2")
{
    int loading1 : 0x2193D0;
    string90 map : 0x21208C;
    int cutscene : 0x216DC4;
    }

startup
{
	settings.Add("missions", true, "Missions");

    vars.missions = new Dictionary<string,string> 
		{ 
    		{"Sewer.World00p","Investigation - Underneath"},
    		{"Streets.World00p","Investigation - Firefight"},
   		 	{"Data_Center.World00p","Revelation - Rescue and Recon"},
    		{"Computer_Core.World00p","Revelation - Disturbance"},
   		 	{"Landing_Zone.World00p","Apprehension - Pacification"},
    		{"Research_facility.World00p","Apprehension - Bio-Research"},
    		{"Plaza.World00p","Apprehension - The Plaza Chase"},
    		{"Underground.World00p","Devastation - Buried"},
    		{"Subway.World00p","Devastation - The Deep"},
    		{"Train_Yard.World00p","Infiltration - Relic"},
    		{"Headquarters.World00p","Infiltration - Base Camp"},
    		{"Mine.World00p","Exploration - Labyrinth"},
    		{"Clone_Labs.World00p","Extermination - Clone Facility"},
    		{"Clone_Production.World00p","Extermination - Clone Production"},
    		{"Escape.World00p","Extermination - Showdown"},
    	};
 		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Fear Perseus Mandate",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }

}

start
{
	return ((current.map == "Introduction.World00p") && (current.loading1 != 0) && (current.cutscene == 0));
}

isLoading
{
    return (current.loading1 == 0) ||
    (current.cutscene != 0);
}

split
{
	return ((current.map != old.map) && (settings[current.map]));
}
