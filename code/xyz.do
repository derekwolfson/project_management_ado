cap pr drop xyz
pr xyz
	vers 12.1

	syntax

	* Determine the type of file that each global holds.
	loc names : all globals
	foreach name of loc names {
		* The global's file type (.do/.dta/directory)
		loc type
		mata: st_local("suffix", pathsuffix(st_global("`name'")))
		if inlist(`"`suffix'"', ".do", ".dta") ///
			loc type : subinstr loc suffix "." ""
		else {
			mata: st_local("is_dir", strofreal(direxists(st_global("`name'"))))
			if `is_dir' ///
				loc type dir
		}

		if "`type'" != "" ///
			loc `type' : list `type' | name
	}
	
	* Sort the lists


	di as txt _n "**DO-FILES**"
	foreach name of loc do {
		di as txt ///
			`"[{stata `"doedit `"$`name'"'"':edit}] "' ///
			`"[{stata `"do `"$`name'"'"':do}] "' ///
			as res `"`name'"'
	}
	
	di as txt _n "**DTA-FILES**"
	foreach name of loc dta {
		di as txt ///
			`"[{stata `"use `"$`name'"'"':use}] "' ///
			as res `"`name'"'
	}
	
	di as txt _n "**PROJECT FOLDERS**"
	foreach name of loc dir {
		di as txt ///
			`"[{stata `"! cd "$`name'" & Start . "':open}] "' ///
			as res `"`name'"'
	}

	// ...
end
xyz
