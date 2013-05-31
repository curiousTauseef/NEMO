BEGIN {
    PROCINFO["sorted_in"] = "@ind_num_asc"
    baseline_demand = 204.4
    merit[0] = "geoth"
    merit[1] = "PV"
    merit[2] = "wind"
    merit[3] = "CST"
    merit[4] = "Coal"
    merit[5] = "Coal-CCS"
    merit[6] = "CCGT"
    merit[7] = "CCGT-CCS"
    merit[8] = "hydro"
    merit[9] = "PSH"
    merit[10] = "GT"
    merit[11] = "OCGT"
    merit[12] = "DM"
}

/geothermal.*GW.?$/	{ caps["geoth"] += $(NF-1); last="geoth" }
/PV.*GW.?$/		{ caps["PV"] += $(NF-1); last="PV" }
/wind.*GW.?$/		{ caps["wind"] += $(NF-1); last="wind" }
/SCST.*GW.?$/		{ caps["CST"] += $(NF-1); last="CST" }
/ hydro.*GW.?$/		{ caps["hydro"] += $(NF-1); last="hydro" }
/pumped-hydro.*GW.?$/	{ caps["PSH"] += $(NF-1); last="PSH" }
/ GT.*GW.?$/		{ caps["GT"] += $(NF-1); last="GT" }
/CCGT-CCS.*GW.?$/	{ caps["CCGT-CCS"] += $(NF-1); last="CCGT-CCS" }
/CCGT .*GW.?$/		{ caps["CCGT"] += $(NF-1); last="CCGT" }
/coal.*GW.?$/		{ caps["Coal"] += $(NF-1); last="Coal" }
/Coal-CCS.*GW.?$/	{ caps["Coal-CCS"] += $(NF-1); last="Coal-CCS" }
/OCGT.*GW.?$/		{ caps["OCGT"] += $(NF-1); last="OCGT" }
/demand.*GW.?$/		{ caps["DM"] += $(NF-1); last="DM" }
/supplied.*TWh/		{ energy[last] += $2 }
/Score:/		{ cost = $2 }

/Demand energy:/ {
    i++
    total_demand = $(NF-1)
    total_capacity = 0
    for (c in caps) {
    	total_capacity += caps[c]
    }
    printf ("scenario\t%d\t%d\t%d\t%d\n", i, i, i, i)
    for (m in merit) {
	c = merit[m]
	if (caps[c] != "")
	    printf ("%s\t%.3f\t%.3f\t%.3f\t%.3f\t%.2f\n", c, \
		    caps[c], (float) caps[c] / total_capacity, \
		    energy[c], (float) energy[c] / total_demand, cost)
    }

    delete caps
    delete energy
    printf ("\n\n")
}
