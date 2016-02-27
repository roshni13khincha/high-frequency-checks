/*----------------------------------------*
 |file:    ipacheckconsent.ado            | 
 |project: high frequency checks          |
 |author:  christopher boyer              |
 |         matthew bombyk                 |
 |         innovations for poverty action |
 |date:    2016-02-13                     |
 *----------------------------------------*/

 // this program checks that all interviews have consent

capture program drop ipacheckconsent
program ipacheckconsent, rclass
	di ""
	di "HFC 3 => Checking that all interviews have consent..."
	qui {

	syntax varlist(max=1),  saving(string) consentvalue(integer) id(varname) enumerator(varname) [sheetmodify sheetreplace]
	
	version 13.1
	 
	 /* Check that all interviews have consent. */
	preserve
		generate noconsent = `varlist' != `consentvalue'
		keep if noconsent
		g message = "Interview is marked with no consent."
		g notes = ""
		g drop = ""
		g newvalue = ""	
		cap local varl: variable label `varlist'
		*cap loc varl = subinstr(`"`varl'"',",","-",.)
		local numnoconsent = _N
		g label = "`varl'"
		g variable = "`varlist'"
		g value = `varlist'
		keep `id' `enumerator' variable label value message notes drop newvalue
		order `id' `enumerator' variable label value message notes drop newvalue
		export excel using `saving' , sheet("3. consent") sheetreplace firstrow(variables) nolabel
	restore
	}
	di "  Found `numnoconsent' interviews with no consent."
	return scalar noconsent = `numnoconsent'
end
