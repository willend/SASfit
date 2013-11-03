# sasfit.vfs/lib/app-sasfit/tcl/sasfit_OZ_solver.tcl
#
# Copyright (c) 2008-2013, Paul Scherrer Institute (PSI)
#
# This file is part of SASfit.
#
# SASfit is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SASfit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SASfit.  If not, see <http://www.gnu.org/licenses/>.

# Author(s) of this file:
#   Joachim Kohlbrecher (joachim.kohlbrecher@psi.ch)

proc put_OZ_res {} {
	global OZ
	lappend OZ(result,closure) 	$OZ(closure)
	lappend OZ(result,potential) 	$OZ(potential)
	lappend OZ(result,p) 		[list $OZ(p0) $OZ(p1) $OZ(p2) $OZ(p3) $OZ(p4) $OZ(p5) $OZ(p6) $OZ(p7) $OZ(p8) $OZ(p9) $OZ(p10) $OZ(p11) $OZ(p12) $OZ(p13) $OZ(p14) $OZ(p15)]
	lappend OZ(result,phi)		$OZ(phi)
	lappend OZ(result,T) 		$OZ(T)
    	lappend OZ(result,1024)		$OZ(1024)
    	lappend OZ(result,mult) 	$OZ(mult)
    	lappend OZ(result,mix) 		$OZ(mix)
    	lappend OZ(result,dr/dsigma) 	$OZ(dr/dsigma)
    	lappend OZ(result,releps)  	$OZ(releps)
    	lappend OZ(result,gridlength)  	$OZ(gridlength)
    	lappend OZ(result,q)  		$OZ(res,s,x)
    	lappend OZ(result,Sq)  		$OZ(res,s,y)
    	lappend OZ(result,r)  		$OZ(res,c,x)
    	lappend OZ(result,cr)  		$OZ(res,c,y)
    	lappend OZ(result,gr)  		$OZ(res,g,y)
    	lappend OZ(result,u,x)          $OZ(res,u,x)
    	lappend OZ(result,Ur)  		$OZ(res,u,y)
    	lappend OZ(result,label)	$OZ(label)
    	.oztop.interface.assigning.assign configure -values $OZ(result,label)
    	.oztop.interface.assigning.assign setvalue last
}

proc pop_OZ_res {} {
	global OZ ozSQGraph ozgrGraph ozcrGraph ozbetaUrGraph
	set OZ(result,closure) 		[lrange $OZ(result,closure) 	0 [expr [llength $OZ(result,closure)]	-2]]
	set OZ(result,potential) 	[lrange $OZ(result,potential) 	0 [expr [llength $OZ(result,potential)]	-2]]
	set OZ(result,p) 		[lrange $OZ(result,p) 		0 [expr [llength $OZ(result,p)]		-2]]
	set OZ(result,phi)		[lrange $OZ(result,phi) 	0 [expr [llength $OZ(result,phi)]	-2]]
	set OZ(result,T) 		[lrange $OZ(result,T) 		0 [expr [llength $OZ(result,T)]		-2]]
    	set OZ(result,1024)		[lrange $OZ(result,1024) 	0 [expr [llength $OZ(result,1024)]	-2]]
    	set OZ(result,mult) 		[lrange $OZ(result,mult) 	0 [expr [llength $OZ(result,mult)]	-2]]
    	set OZ(result,mix) 		[lrange $OZ(result,mix) 	0 [expr [llength $OZ(result,mix)]	-2]]
    	set OZ(result,dr/dsigma) 	[lrange $OZ(result,dr/dsigma) 	0 [expr [llength $OZ(result,dr/dsigma)]	-2]]
    	set OZ(result,releps)  		[lrange $OZ(result,releps)	0 [expr [llength $OZ(result,releps)]	-2]]
    	set OZ(result,gridlength)  	[lrange $OZ(result,gridlength) 	0 [expr [llength $OZ(result,gridlength)] -2]]
    	set OZ(result,q)  		[lrange $OZ(result,q) 		0 [expr [llength $OZ(result,q)]		-2]]
    	set OZ(result,Sq)  		[lrange $OZ(result,Sq) 		0 [expr [llength $OZ(result,Sq)]	-2]]
    	set OZ(result,r)  		[lrange $OZ(result,r) 		0 [expr [llength $OZ(result,r)]		-2]]
    	set OZ(result,cr)  		[lrange $OZ(result,cr) 		0 [expr [llength $OZ(result,cr)]	-2]]
    	set OZ(result,gr)  		[lrange $OZ(result,gr) 		0 [expr [llength $OZ(result,gr)]	-2]]
    	set OZ(result,u,x)          	[lrange $OZ(result,u,x) 	0 [expr [llength $OZ(result,u,x)]	-2]]
    	set OZ(result,Ur)  		[lrange $OZ(result,Ur) 		0 [expr [llength $OZ(result,Ur)]	-2]]
    	set OZ(result,label)		[lrange $OZ(result,label) 	0 [expr [llength $OZ(result,label)]	-2]]
    	Pop_Graph_el ozSQGraph
    	Pop_Graph_el ozgrGraph
    	Pop_Graph_el ozcrGraph
    	Pop_Graph_el ozbetaUrGraph
    	incr OZ(plottedgraphs) -1
    	.oztop.interface.assigning.assign configure -values $OZ(result,label)
    	.oztop.interface.assigning.assign setvalue last
}


proc StartOZsolver {} {
        global OZ ozSQGraph ozgrGraph ozcrGraph ozbetaUrGraph sasfit
        sasfit_timer_start "Start OZ Solver"
        sasfit_oz_calc OZ
	sasfit_timer_stop "OZ solver" "calculation finished" "."
	
	sasfit_timer_start "Start plotting OZ Solver results"
        if {$OZ(color_i) >= [llength $ozSQGraph(colorselection)]} {
            set OZ(color_i) 0
            incr OZ(symbol_i)
            if {$OZ(symbol_i) >= [llength $ozSQGraph(symbolselection)]} {set $OZ(symbol_i) 0}
        }
        set color_n  [lindex $ozSQGraph(colorselection)  $OZ(color_i)]
        set symbol_n [lindex $ozSQGraph(symbolselection) $OZ(symbol_i)]
        set count_n  $OZ(plottedgraphs)

        incr OZ(color_i)

        #clearGraph_el ozSQGraph
        set ozSQGraph(x,type) arcsinh(x)
        Put_Graph_el ozSQGraph $OZ(res,s,x) $OZ(res,s,y)

        set ozSQGraph(e,linehide)   [lreplace $ozSQGraph(e,linehide)   $count_n  $count_n 1]
        set ozSQGraph(e,dashcolor)  [lreplace $ozSQGraph(e,dashcolor)  $count_n  $count_n $color_n]
        set ozSQGraph(e,fill)       [lreplace $ozSQGraph(e,fill)       $count_n  $count_n $color_n]
        set ozSQGraph(e,outline)    [lreplace $ozSQGraph(e,outline)    $count_n  $count_n $color_n]
        set ozSQGraph(e,symbol)     [lreplace $ozSQGraph(e,symbol)     $count_n  $count_n $symbol_n]
        set ozSQGraph(l,legendtext) [lreplace $ozSQGraph(l,legendtext) $count_n  $count_n $OZ(label)]
        RefreshGraph ozSQGraph

        #clearGraph_el ozcrGraph 
        set ozcrGraph(x,type) arcsinh(x)
        Put_Graph_el ozcrGraph $OZ(res,c,x) $OZ(res,c,y)
        set ozcrGraph(e,linehide)   [lreplace $ozcrGraph(e,linehide)   $count_n  $count_n 1]
        set ozcrGraph(e,dashcolor)  [lreplace $ozcrGraph(e,dashcolor)  $count_n  $count_n $color_n]
        set ozcrGraph(e,fill)       [lreplace $ozcrGraph(e,fill)       $count_n  $count_n $color_n]
        set ozcrGraph(e,outline)    [lreplace $ozcrGraph(e,outline)    $count_n  $count_n $color_n]
        set ozcrGraph(l,legendtext) [lreplace $ozcrGraph(l,legendtext) $count_n  $count_n $OZ(label)]
        set ozcrGraph(e,symbol)     [lreplace $ozcrGraph(e,symbol)     $count_n  $count_n $symbol_n]
        RefreshGraph ozcrGraph

        #clearGraph_el ozgrGraph 
        set ozgrGraph(x,type) arcsinh(x)
        Put_Graph_el ozgrGraph $OZ(res,g,x) $OZ(res,g,y)
        set ozgrGraph(e,linehide)   [lreplace $ozgrGraph(e,linehide)   $count_n  $count_n 1]
        set ozgrGraph(e,dashcolor)  [lreplace $ozgrGraph(e,dashcolor)  $count_n  $count_n $color_n]
        set ozgrGraph(e,fill)       [lreplace $ozgrGraph(e,fill)       $count_n  $count_n $color_n]
        set ozgrGraph(e,outline)    [lreplace $ozgrGraph(e,outline)    $count_n  $count_n $color_n]
        set ozgrGraph(l,legendtext) [lreplace $ozgrGraph(l,legendtext) $count_n  $count_n $OZ(label)]
        set ozgrGraph(e,symbol)     [lreplace $ozgrGraph(e,symbol)     $count_n  $count_n $symbol_n]
        RefreshGraph ozgrGraph

        #clearGraph_el ozbetaUrGraph 
        set ozbetaUrGraph(x,type) arcsinh(x)
        Put_Graph_el ozbetaUrGraph $OZ(res,u,x) $OZ(res,u,y)
        set ozbetaUrGraph(e,linehide)   [lreplace $ozbetaUrGraph(e,linehide)   $count_n  $count_n 1]
        set ozbetaUrGraph(e,dashcolor)  [lreplace $ozbetaUrGraph(e,dashcolor)  $count_n  $count_n $color_n]
        set ozbetaUrGraph(e,fill)       [lreplace $ozbetaUrGraph(e,fill)       $count_n  $count_n $color_n]
        set ozbetaUrGraph(e,outline)    [lreplace $ozbetaUrGraph(e,outline)    $count_n  $count_n $color_n]
        set ozbetaUrGraph(l,legendtext) [lreplace $ozbetaUrGraph(l,legendtext) $count_n  $count_n $OZ(label)]
        set ozbetaUrGraph(e,symbol)     [lreplace $ozbetaUrGraph(e,symbol)     $count_n  $count_n $symbol_n]
        RefreshGraph ozbetaUrGraph

        incr  OZ(plottedgraphs)
        put_OZ_res
        sasfit_timer_stop "Plotting OZ solver results" "plotting finished" "."
        set OZ(progressbar) 0
}


proc ReplotOZsolver {} {
   global OZ ozSQGraph ozgrGraph ozcrGraph ozbetaUrGraph sasfit
   set OZ(color_i) 0
   set OZ(symbol_i) 0
   set OZ(plottedgraphs) 0
   set OZ(progressbar) 1
	
   for {set i 0} {$i < [llength $OZ(result,q)]} {incr i} {
	sasfit_timer_start "Start replotting OZ Solver result $i"
	set OZ(res,s,x) [lindex $OZ(result,q)  $i]
	set OZ(res,s,y) [lindex $OZ(result,Sq) $i]
	set OZ(res,c,x) [lindex $OZ(result,r)  $i]
	set OZ(res,c,y) [lindex $OZ(result,cr) $i]
	set OZ(res,g,x) [lindex $OZ(result,r)  $i]
	set OZ(res,g,y) [lindex $OZ(result,gr) $i]
	set OZ(res,u,x) [lindex $OZ(result,u,x) $i]
	set OZ(res,u,y) [lindex $OZ(result,Ur) $i]
	set OZ(label)   [lindex $OZ(result,label) $i]
        if {$OZ(color_i) >= [llength $ozSQGraph(colorselection)]} {
            set OZ(color_i) 0
            incr OZ(symbol_i)
            if {$OZ(symbol_i) >= [llength $ozSQGraph(symbolselection)]} {set $OZ(symbol_i) 0}
        }
        set color_n  [lindex $ozSQGraph(colorselection)  $OZ(color_i)]
        set symbol_n [lindex $ozSQGraph(symbolselection) $OZ(symbol_i)]
        set count_n  $OZ(plottedgraphs)

        incr OZ(color_i)

        #clearGraph_el ozSQGraph
        set ozSQGraph(x,type) arcsinh(x)
        Put_Graph_el ozSQGraph $OZ(res,s,x) $OZ(res,s,y)
        set ozSQGraph(e,linehide)   [lreplace $ozSQGraph(e,linehide)   $count_n  $count_n 1]
        set ozSQGraph(e,dashcolor)  [lreplace $ozSQGraph(e,dashcolor)  $count_n  $count_n $color_n]
        set ozSQGraph(e,fill)       [lreplace $ozSQGraph(e,fill)       $count_n  $count_n $color_n]
        set ozSQGraph(e,outline)    [lreplace $ozSQGraph(e,outline)    $count_n  $count_n $color_n]
        set ozSQGraph(e,symbol)     [lreplace $ozSQGraph(e,symbol)     $count_n  $count_n $symbol_n]
        set ozSQGraph(l,legendtext) [lreplace $ozSQGraph(l,legendtext) $count_n  $count_n $OZ(label)]
        RefreshGraph ozSQGraph
        incr OZ(progressbar) 

        #clearGraph_el ozcrGraph 
        set ozcrGraph(x,type) arcsinh(x)
        Put_Graph_el ozcrGraph $OZ(res,c,x) $OZ(res,c,y)
        set ozcrGraph(e,linehide)   [lreplace $ozcrGraph(e,linehide)   $count_n  $count_n 1]
        set ozcrGraph(e,dashcolor)  [lreplace $ozcrGraph(e,dashcolor)  $count_n  $count_n $color_n]
        set ozcrGraph(e,fill)       [lreplace $ozcrGraph(e,fill)       $count_n  $count_n $color_n]
        set ozcrGraph(e,outline)    [lreplace $ozcrGraph(e,outline)    $count_n  $count_n $color_n]
        set ozcrGraph(l,legendtext) [lreplace $ozcrGraph(l,legendtext) $count_n  $count_n $OZ(label)]
        set ozcrGraph(e,symbol)     [lreplace $ozcrGraph(e,symbol)     $count_n  $count_n $symbol_n]
        RefreshGraph ozcrGraph
        incr OZ(progressbar) 

        #clearGraph_el ozgrGraph 
        set ozgrGraph(x,type) arcsinh(x)
        Put_Graph_el ozgrGraph $OZ(res,g,x) $OZ(res,g,y)
        set ozgrGraph(e,linehide)   [lreplace $ozgrGraph(e,linehide)   $count_n  $count_n 1]
        set ozgrGraph(e,dashcolor)  [lreplace $ozgrGraph(e,dashcolor)  $count_n  $count_n $color_n]
        set ozgrGraph(e,fill)       [lreplace $ozgrGraph(e,fill)       $count_n  $count_n $color_n]
        set ozgrGraph(e,outline)    [lreplace $ozgrGraph(e,outline)    $count_n  $count_n $color_n]
        set ozgrGraph(l,legendtext) [lreplace $ozgrGraph(l,legendtext) $count_n  $count_n $OZ(label)]
        set ozgrGraph(e,symbol)     [lreplace $ozgrGraph(e,symbol)     $count_n  $count_n $symbol_n]
        RefreshGraph ozgrGraph
        incr OZ(progressbar) 
	
        #clearGraph_el ozbetaUrGraph 
        set ozbetaUrGraph(x,type) arcsinh(x)
        Put_Graph_el ozbetaUrGraph $OZ(res,u,x) $OZ(res,u,y)
        set ozbetaUrGraph(e,linehide)   [lreplace $ozbetaUrGraph(e,linehide)   $count_n  $count_n 1]
        set ozbetaUrGraph(e,dashcolor)  [lreplace $ozbetaUrGraph(e,dashcolor)  $count_n  $count_n $color_n]
        set ozbetaUrGraph(e,fill)       [lreplace $ozbetaUrGraph(e,fill)       $count_n  $count_n $color_n]
        set ozbetaUrGraph(e,outline)    [lreplace $ozbetaUrGraph(e,outline)    $count_n  $count_n $color_n]
        set ozbetaUrGraph(l,legendtext) [lreplace $ozbetaUrGraph(l,legendtext) $count_n  $count_n $OZ(label)]
        set ozbetaUrGraph(e,symbol)     [lreplace $ozbetaUrGraph(e,symbol)     $count_n  $count_n $symbol_n]
        RefreshGraph ozbetaUrGraph
        incr OZ(progressbar) 

        sasfit_timer_stop "Relotting $i-th OZ solver result" "plotting finished" "."
        incr OZ(progressbar) 
        incr OZ(plottedgraphs)
    }
    set OZ(progressbar) 0
}

proc ClearOZsolver {} {
    global ozSQGraph ozcrGraph ozgrGraph ozbetaUrGraph OZ
    clearGraph_el ozSQGraph
    clearGraph_el ozcrGraph 
    clearGraph_el ozgrGraph 
    clearGraph_el ozbetaUrGraph 
    set OZ(color_i) 0
    set OZ(symbol_i) 0
    set OZ(plottedgraphs) 0
    
    set OZ(result,closure) {}
    set OZ(result,potential) {}
    set OZ(result,p) {}
    set OZ(result,phi) {}
    set OZ(result,T) {}
    set OZ(result,1024) {}
    set OZ(result,mult) {}
    set OZ(result,mix) {}
    set OZ(result,dr/dsigma) {}
    set OZ(result,releps) {}
    set OZ(result,gridlength) {}
    set OZ(result,q) {}
    set OZ(result,Sq) {}
    set OZ(result,r) {}
    set OZ(result,cr) {}
    set OZ(result,gr) {}
    set OZ(result,u,x) {}
    set OZ(result,Ur) {}
    set OZ(result,label) {}
    .oztop.interface.assigning.assign configure -text ""
    .oztop.interface.assigning.assign configure -values $OZ(result,label)
    .oztop.interface.assigning.assign setvalue last
}

proc oz_input_names {} {
	global OZ
	switch $OZ(potential) {
		HardSphere {
			set OZ(p0,name) diameter
			set OZ(p1,name) ""
			set OZ(p2,name) ""
			set OZ(p3,name) ""
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
		StickyHardSphere {
			set OZ(p0,name) diameter
			set OZ(p1,name) tau
			set OZ(p2,name) delta
			set OZ(p3,name) ""
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
		SoftSphere {
			set OZ(p0,name) diameter
			set OZ(p1,name) epsilon
			set OZ(p2,name) ""
			set OZ(p3,name) ""
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
		LennardJones {
			set OZ(p0,name) diameter
			set OZ(p1,name) epsilon
			set OZ(p2,name) ""
			set OZ(p3,name) ""
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
		Depletion {
			set OZ(p0,name) diameter
			set OZ(p1,name) "diam. (small)"
			set OZ(p2,name) "phi (small)"
			set OZ(p3,name) ""
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
		IonicMicrogel {
			set OZ(p0,name) diameter
			set OZ(p1,name) Z
			set OZ(p2,name) ed
			set OZ(p3,name) kpi
			set OZ(p4,name) epsilon
			set OZ(p5,name) ""
			}
		PenetrableSphere {
			set OZ(p0,name) diameter
			set OZ(p1,name) epsilon
			set OZ(p2,name) ""
			set OZ(p3,name) ""
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
		DLVO {
			set OZ(p0,name) diameter
			set OZ(p1,name) kappa
			set OZ(p2,name) Z
			set OZ(p3,name) LB
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
		"GGCM-n" {
			set OZ(p0,name) diameter
			set OZ(p1,name) epsilon
			set OZ(p2,name) n
			set OZ(p3,name) alpha
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
		default {
			set OZ(p0,name) ""
			set OZ(p1,name) ""
			set OZ(p2,name) ""
			set OZ(p3,name) ""
			set OZ(p4,name) ""
			set OZ(p5,name) ""
			}
	}
}

proc update_ozmenu {} {
    global OZ
    set w .oztop.interface.assigning.assign
    set idx [$w getvalue]
    if {$idx >=0} {
       set OZ(closure)	 [lindex $OZ(result,closure) $idx]
       set OZ(potential) [lindex $OZ(result,potential) $idx]
       oz_input_names
       set OZ(p)	 [lindex $OZ(result,p) $idx]
       for {set i 0} {$i < 16} {incr i} {
           set OZ(p$i) [lindex $OZ(p) $i]
       }
       set OZ(phi)	[lindex $OZ(result,phi) $idx]
       set OZ(T)	[lindex $OZ(result,T) $idx]
       set OZ(1024)	[lindex $OZ(result,1024) $idx]
       set OZ(mult)	[lindex $OZ(result,mult) $idx]
       set OZ(mix)	[lindex $OZ(result,mix) $idx]
       set OZ(dr/dsigma) [lindex $OZ(result,dr/dsigma) $idx]
       set OZ(releps)	[lindex $OZ(result,releps) $idx]
       set OZ(gridlength)	[lindex $OZ(result,gridlength) $idx]
#       set [lindex $OZ(result,q) $idx]
#       set [lindex $OZ(result,Sq) $idx]
#       set [lindex $OZ(result,r) $idx]
#       set [lindex $OZ(result,cr) $idx]
#       set [lindex $OZ(result,gr) $idx]
#       set [lindex $OZ(result,Ur) $idx]
       set OZ(label)	[lindex $OZ(result,label) $idx]
    }
    puts "index: $idx"
	
}

proc sasfit_OZ_solver {} {
    global sasfit ozSQGraph ozgrGraph ozcrGraph ozbetaUrGraph OZ
    set w .oztop
    if {[winfo exists $w]} {destroy $w}
    toplevel .oztop
    wm geometry $w
    wm title .oztop "Ornstein Zernike solver"
    raise $w

#------------------------------------------------------------------------------
#                               Create OZ tabs

#
#  creating tabset
#
    blt::tabset .oztop.tab -relief sunken -borderwidth 2 
    frame $w.interface 
    frame $w.interface.param   
    frame $w.interface.action   
    frame $w.interface.assigning 
    frame $w.interface.progressbar
    
    set OZ(progressbar) 0
    
    label $w.interface.progressbar.label -text "progress:"
    ProgressBar $w.interface.progressbar.value \
    		-maximum 100 -width 50m\
    		-type infinite -variable OZ(progressbar)
    pack $w.interface.progressbar.label $w.interface.progressbar.value \
    		-fill both  -expand yes -side left -pady 2m
    
    pack .oztop.tab  -fill both  -expand yes -side right
    pack $w.interface -side left
    pack  $w.interface.param $w.interface.action $w.interface.assigning $w.interface.progressbar -fill y
    
    button  $w.interface.action.calc -text calculate -command {StartOZsolver}
    button  $w.interface.action.clear -text clear -command {ClearOZsolver}
    button  $w.interface.action.del -text "del last" -command {pop_OZ_res}
    ComboBox $w.interface.assigning.sqplugin \
	    -values $OZ(plugin_fct_names) \
            -text "SQ oz 1" -editable 0 -width 8
    ComboBox $w.interface.assigning.assign -editable 0 -width 14 \
    	-modifycmd {
    		update_ozmenu
    	}
    .oztop.interface.assigning.assign configure -values $OZ(result,label)
    .oztop.interface.assigning.assign setvalue first
    button   $w.interface.assigning.doassign -text assign \
    	-command {
    		set w .oztop.interface.assigning.assign
    		set plugin_fct [.oztop.interface.assigning.sqplugin getvalue]
    		set q  [lindex $OZ(result,q)  $plugin_fct]
		set Sq [lindex $OZ(result,Sq) $plugin_fct]
		set p  [lindex $OZ(result,p)  $plugin_fct]
		set sigma [lindex $p 0]
		set qsigma {}
		foreach Q $q {
			set QSIGMA [expr $Q*$sigma]
			lappend qsigma $QSIGMA
		}
    		sasfit_oz_assign_data [lindex $OZ(plugin_C_names) $plugin_fct] $qsigma $Sq
    	}
    label    $w.interface.assigning.to -text to

    pack $w.interface.action.calc $w.interface.action.clear $w.interface.action.del \
    	-side left  -padx 2mm -pady 4mm
    pack $w.interface.assigning.doassign \
	 $w.interface.assigning.assign \
	 $w.interface.assigning.to \
         $w.interface.assigning.sqplugin  -side left
 
    set w .oztop.interface
    label $w.param.cltext -text "closure relation:"
    label $w.param.pottext -text "potential:"
    grid $w.param.cltext  -sticky e\
	    -column 0 -row 0
    grid $w.param.pottext  -sticky e\
	    -column 0 -row 1
    ComboBox $w.param.clvalue \
	    -values {PY HNC RHNC MSA mMSA SMSA RY Verlet MS BPGG} \
	    -textvariable OZ(closure)
    grid  $w.param.clvalue\
	    -column 1 -row 0
    ComboBox $w.param.potvalue \
	    -values {"HardSphere" "StickyHardSphere" "SoftSphere" "StarPolymer" \
	    		"LennardJones" "Depletion" "IonicMicrogel"  \
	    		"PenetrableSphere" "DLVO" "GGCM-n"} \
	    -textvariable OZ(potential) \
	    -modifycmd {oz_input_names}
    grid  $w.param.potvalue\
	    -column 1 -row 1

    label $w.param.empty1 -text "input parameters for U(r):" -anchor w -justify left -font "Arial 10 bold underline"
    label $w.param.v0text -anchor e -justify right -textvariable OZ(p0,name)
    label $w.param.v1text -anchor e -justify right -textvariable OZ(p1,name)
    label $w.param.v2text -anchor e -justify right -textvariable OZ(p2,name)
    label $w.param.v3text -anchor e -justify right -textvariable OZ(p3,name)
    label $w.param.v4text -anchor e -justify right -textvariable OZ(p4,name)
    label $w.param.v5text -anchor e -justify right -textvariable OZ(p5,name)
    
    grid  $w.param.empty1 \
	    -column 0 -row 2 -columnspan 2 -sticky w
    grid  $w.param.v0text -sticky e\
	    -column 0 -row 3  
    grid  $w.param.v1text -sticky e\
	    -column 0 -row 4  
    grid  $w.param.v2text -sticky e\
	    -column 0 -row 5  
    grid  $w.param.v3text -sticky e\
	    -column 0 -row 6  
    grid  $w.param.v4text -sticky e\
	    -column 0 -row 7  
    grid  $w.param.v5text -sticky e\
	    -column 0 -row 8

    entry $w.param.v0value -textvariable OZ(p0)
    entry $w.param.v1value -textvariable OZ(p1)
    entry $w.param.v2value -textvariable OZ(p2)
    entry $w.param.v3value -textvariable OZ(p3)
    entry $w.param.v4value -textvariable OZ(p4)
    entry $w.param.v5value -textvariable OZ(p5)  
    grid  $w.param.v0value\
	    -column 1 -row 3  
    grid  $w.param.v1value\
	    -column 1 -row 4  
    grid  $w.param.v2value\
	    -column 1 -row 5  
    grid  $w.param.v3value\
	    -column 1 -row 6  
    grid  $w.param.v4value\
	    -column 1 -row 7  
    grid  $w.param.v5value\
	    -column 1 -row 8

    label $w.param.empty2 -text "parameters for OZ solver:" -font "Arial 10 bold underline"
    label $w.param.phitext -text "volume fraction:"  
    entry $w.param.phivalue -textvariable OZ(phi)
    label $w.param.ttext -text "temperature \[K\]:"  
    entry $w.param.tvalue -textvariable OZ(T)
    
    grid  $w.param.empty2 -sticky w\
	    -column 0 -row 9 -columnspan 2
    grid  $w.param.phitext -sticky e\
	    -column 0 -row 10
    grid  $w.param.ttext -sticky e\
	    -column 0 -row 11
    grid  $w.param.phivalue\
	    -column 1 -row 10
    grid  $w.param.tvalue\
	    -column 1 -row 11

    label $w.param.empty3 -text " "
    label $w.param.gridtext -text "gridsize (n x 1024), n:"  
    entry $w.param.gridvalue -textvariable OZ(mult)
    label $w.param.mixtext -text "mixing parameter:"  
    entry $w.param.mixvalue -textvariable OZ(mix)
    label $w.param.ittext -text "max iterations:"  
    entry $w.param.itvalue -textvariable OZ(maxit)
    label $w.param.relepstext -text "rel. iteration precision:"  
    entry $w.param.relepsvalue -textvariable OZ(releps) 
    label $w.param.drdsigmatext -text "rel. grid step width:" 
    entry $w.param.drdsigmavalue -textvariable OZ(dr/dsigma)
    
    grid $w.param.empty3 \
	    -column 0 -row 11
    grid  $w.param.gridtext -sticky e\
	    -column 0 -row 12
    grid  $w.param.mixtext -sticky e\
	    -column 0 -row 13
    grid  $w.param.ittext -sticky e\
	    -column 0 -row 14
    grid  $w.param.relepstext -sticky e\
	    -column 0 -row 15
    grid  $w.param.drdsigmatext -sticky e\
	    -column 0 -row 16
    grid  $w.param.gridvalue \
	    -column 1 -row 12
    grid  $w.param.mixvalue \
	    -column 1 -row 13
    grid  $w.param.itvalue \
	    -column 1 -row 14
    grid  $w.param.relepsvalue \
	    -column 1 -row 15
    grid  $w.param.drdsigmavalue \
	    -column 1 -row 16

    label $w.param.empty4 -text " "
    label $w.param.labeltext -text "label:"  
    entry $w.param.labelvalue -textvariable OZ(label)
    grid $w.param.empty4 \
	    -column 0 -row 17
    grid  $w.param.labeltext -sticky e\
	    -column 0 -row 18
    grid  $w.param.labelvalue \
	    -column 1 -row 18

#
#  create "ozSQGraph"
#
    frame .oztop.tab.sq -relief groove -borderwidth 2 
    set ozSQGraph(w) .oztop.tab.sq.draw
    set ozSQGraph(e,element) 0
    CreateGraph ozSQGraph
    set ozSQGraph(x,logscale) 0
    set ozSQGraph(y,logscale) 0
    set ozSQGraph(x,type)     x
    set ozSQGraph(y,type)     y
    set ozSQGraph(x,title) "Q / nm^-1"
    set ozSQGraph(y,title) "S(Q)"
    set ozSQGraph(l,hide)  no
    pack $ozSQGraph(w) -in .oztop.tab.sq
    pack configure $ozSQGraph(w) -fill both -expand yes

   .oztop.tab insert 0 ozSQGraph
   .oztop.tab tab configure ozSQGraph -text "structure factor\nS(Q)"
   .oztop.tab tab configure ozSQGraph -fill both -padx 0.1i -pady 0.1i \
            -window .oztop.tab.sq -windowheight $sasfit(height) -windowwidth $sasfit(width) 
            

##
## creating ozSQ popup menu
##
    menu .oztop.tab.sq.popup -tearoff 0
    .oztop.tab.sq.popup add command -label "copy to clipboard (wmf)" -un 0 -command {
	window_to_clipboard .oztop.tab.sq
    }
    .oztop.tab.sq.popup add command -label "copy to clipboard (ascii)" -un 0 -command {
     	global ozSQGraph
     	export_clipboard_data ozSQGraph
    }
    .oztop.tab.sq.popup add cascade -label "Graph" -un 0 -menu .oztop.tab.sq.popup.graph
    set m3 [menu .oztop.tab.sq.popup.graph -tearoff 1]
    $m3 add command -label "autoscale" \
    	-command { 
    	   global ozSQGraph
    	   set ozSQGraph(x,min) ""
    	   set ozSQGraph(x,max) ""
    	   set ozSQGraph(y,min) ""
    	   set ozSQGraph(y,max) ""
    	   RefreshGraph ozSQGraph
    	}
    $m3 add command -label "x-axis..." -command {
                                          global ozSQGraph
                                          set_xaxis_layout ozSQGraph
                                       }
    $m3 add command -label "y-axis..." -command {
                                          set_yaxis_layout ozSQGraph
                                       }
    $m3 add command -label "graph layout..." -command {
                                               set_graph_layout ozSQGraph
                                             }
    $m3 add command -label "plot layout..." -command {
                                               set_plot_layout ozSQGraph
                                            }
    .oztop.tab.sq.popup add command -label "Export Data..." \
    	-command { export_blt_graph ozSQGraph }
    bind .oztop.tab.sq.draw <Double-ButtonPress-3> {tk_popup .oztop.tab.sq.popup %X %Y }
    bind .oztop.tab.sq.draw <Double-ButtonPress-1> {tk_popup .oztop.tab.sq.popup %X %Y }
    Blt_ZoomStack $ozSQGraph(w)
#
#  create "ozgrGraph"
#

    frame .oztop.tab.gr -relief groove -borderwidth 2 
    set ozgrGraph(w) .oztop.tab.gr.draw
    set ozgrGraph(e,element) 0
    CreateGraph ozgrGraph
    set ozgrGraph(x,logscale) 0
    set ozgrGraph(y,logscale) 0
    set ozgrGraph(x,type)     x
    set ozgrGraph(y,type)     y
    set ozgrGraph(x,title) "r / nm"
    set ozgrGraph(y,title) "g(r))"
    set ozgrGraph(l,hide)  no
    pack $ozgrGraph(w) -in .oztop.tab.gr
    pack configure $ozgrGraph(w) -fill both -expand yes

   .oztop.tab insert 1 ozgrGraph
   .oztop.tab tab configure ozgrGraph -text "radial distribution\nfunction g(r)"
   .oztop.tab tab configure ozgrGraph -fill both -padx 0.1i -pady 0.1i \
            -window .oztop.tab.gr -windowheight $sasfit(height) -windowwidth $sasfit(width)
            
##
## creating ozgr popup menu
##
    menu .oztop.tab.gr.popup -tearoff 0
    .oztop.tab.gr.popup add command -label "copy to clipboard (wmf)" -un 0 -command {
	window_to_clipboard .oztop.tab.gr
    }
    .oztop.tab.gr.popup add command -label "copy to clipboard (ascii)" -un 0 -command {
     	global ozgrGraph
     	export_clipboard_data ozgrGraph
    }
    .oztop.tab.gr.popup add cascade -label "Graph" -un 0 -menu .oztop.tab.gr.popup.graph
    set m3 [menu .oztop.tab.gr.popup.graph -tearoff 1]
    $m3 add command -label "autoscale" \
    	-command { 
    	   global ozgrGraph
    	   set ozgrGraph(x,min) ""
    	   set ozgrGraph(x,max) ""
    	   set ozgrGraph(y,min) ""
    	   set ozgrGraph(y,max) ""
    	   RefreshGraph ozgrGraph
    	}
    $m3 add command -label "x-axis..." -command {
                                          global ozgrGraph
                                          set_xaxis_layout ozgrGraph
                                       }
    $m3 add command -label "y-axis..." -command {
                                          set_yaxis_layout ozgrGraph
                                       }
    $m3 add command -label "graph layout..." -command {
                                               set_graph_layout ozgrGraph
                                             }
    $m3 add command -label "plot layout..." -command {
                                               set_plot_layout ozgrGraph
                                            }
    .oztop.tab.gr.popup add command -label "Export Data..." \
    	-command { export_blt_graph ozgrGraph }
    bind .oztop.tab.gr.draw <Double-ButtonPress-3> {tk_popup .oztop.tab.gr.popup %X %Y }
    bind .oztop.tab.gr.draw <Double-ButtonPress-1> {tk_popup .oztop.tab.gr.popup %X %Y }
    Blt_ZoomStack $ozgrGraph(w)

#
#  create "ozcrGraph"
#

    frame .oztop.tab.cr -relief groove -borderwidth 2 
    set ozcrGraph(w) .oztop.tab.cr.draw
    set ozcrGraph(e,element) 0
    CreateGraph ozcrGraph
    set ozcrGraph(x,logscale) 0
    set ozcrGraph(y,logscale) 0
    set ozcrGraph(x,type)     x
    set ozcrGraph(y,type)     y
    set ozcrGraph(x,title) "r / nm"
    set ozcrGraph(y,title) "c(r)"
    set ozcrGraph(l,hide)  no
    pack $ozcrGraph(w) -in .oztop.tab.cr
    pack configure $ozcrGraph(w) -fill both -expand yes

   .oztop.tab insert 2 ozcrGraph
   .oztop.tab tab configure ozcrGraph -text "direct correlation\nfunction c(r)"
   .oztop.tab tab configure ozcrGraph -fill both -padx 0.1i -pady 0.1i \
            -window .oztop.tab.cr -windowheight $sasfit(height) -windowwidth $sasfit(width)
            
##
## creating ozcr popup menu
##
    menu .oztop.tab.cr.popup -tearoff 0
    .oztop.tab.cr.popup add command -label "copy to clipboard (wmf)" -un 0 -command {
	window_to_clipboard .oztop.tab.cr
    }
    .oztop.tab.cr.popup add command -label "copy to clipboard (ascii)" -un 0 -command {
     	global ozcrGraph
     	export_clipboard_data ozcrGraph
    }
    .oztop.tab.cr.popup add cascade -label "Graph" -un 0 -menu .oztop.tab.cr.popup.graph
    set m3 [menu .oztop.tab.cr.popup.graph -tearoff 1]
    $m3 add command -label "autoscale" \
    	-command { 
    	   global ozcrGraph
    	   set ozcrGraph(x,min) ""
    	   set ozcrGraph(x,max) ""
    	   set ozcrGraph(y,min) ""
    	   set ozcrGraph(y,max) ""
    	   RefreshGraph ozcrGraph
    	}
    $m3 add command -label "x-axis..." -command {
                                          global ozcrGraph
                                          set_xaxis_layout ozcrGraph
                                       }
    $m3 add command -label "y-axis..." -command {
                                          set_yaxis_layout ozcrGraph
                                       }
    $m3 add command -label "graph layout..." -command {
                                               set_graph_layout ozcrGraph
                                             }
    $m3 add command -label "plot layout..." -command {
                                               set_plot_layout ozcrGraph
                                            }
    .oztop.tab.cr.popup add command -label "Export Data..." \
    	-command { export_blt_graph ozcrGraph }
    bind .oztop.tab.cr.draw <Double-ButtonPress-3> {tk_popup .oztop.tab.cr.popup %X %Y }
    bind .oztop.tab.cr.draw <Double-ButtonPress-1> {tk_popup .oztop.tab.cr.popup %X %Y }
    Blt_ZoomStack $ozcrGraph(w)

#
#  create "ozbetaUrGraph"
#

    frame .oztop.tab.betaUr -relief groove -borderwidth 2 
    set ozbetaUrGraph(w) .oztop.tab.betaUr.draw
    set ozbetaUrGraph(e,element) 0
    CreateGraph ozbetaUrGraph
    set oznetaUrGraph(x,logscale) 0
    set ozbetaUrGraph(y,logscale) 0
    set ozbetaUrGraph(x,type)     x
    set ozbetaUrGraph(y,type)     y
    set ozbetaUrGraph(x,title) "r / nm"
    set ozbetaUrGraph(y,title) "U(r)/(kB*T)"
    set ozbetaUrGraph(l,hide)  no
    pack $ozbetaUrGraph(w) -in .oztop.tab.betaUr
    pack configure $ozbetaUrGraph(w) -fill both -expand yes

   .oztop.tab insert 3 ozbetaUrGraph
   .oztop.tab tab configure ozbetaUrGraph -text "interaction potential\nU(r)/(kB*T)"
   .oztop.tab tab configure ozbetaUrGraph -fill both -padx 0.1i -pady 0.1i \
            -window .oztop.tab.betaUr -windowheight $sasfit(height) -windowwidth $sasfit(width) 
 ##
 ## creating ozgr popup menu
 ##
     menu .oztop.tab.betaUr.popup -tearoff 0
     .oztop.tab.betaUr.popup add command -label "copy to clipboard (wmf)" -un 0 -command {
 	window_to_clipboard .oztop.tab.betaUr
     }
     .oztop.tab.betaUr.popup add command -label "copy to clipboard (ascii)" -un 0 -command {
      	global ozbetaUrGraph
      	export_clipboard_data ozbetaUrGraph
     }
     .oztop.tab.betaUr.popup add cascade -label "Graph" -un 0 -menu .oztop.tab.betaUr.popup.graph
     set m3 [menu .oztop.tab.betaUr.popup.graph -tearoff 1]
     $m3 add command -label "autoscale" \
     	-command {
     	   global ozbetaUrGraph
     	   set ozbetaUrGraph(x,min) ""
     	   set ozbetaUrGraph(x,max) ""
     	   set ozbetaUrGraph(y,min) ""
     	   set ozbetaUrGraph(y,max) ""
     	   RefreshGraph ozbetaUrGraph
     	}
     $m3 add command -label "x-axis..." -command {
                                           global ozbetaUrGraph
                                           set_xaxis_layout ozbetaUrGraph
                                        }
     $m3 add command -label "y-axis..." -command {
                                           set_yaxis_layout ozbetaUrGraph
                                        }
     $m3 add command -label "graph layout..." -command {
                                                set_graph_layout ozbetaUrGraph
                                              }
     $m3 add command -label "plot layout..." -command {
                                                set_plot_layout ozbetaUrGraph
                                             }
     .oztop.tab.betaUr.popup add command -label "Export Data..." \
     	-command { export_blt_graph ozbetaUrGraph }
     bind .oztop.tab.betaUr.draw <Double-ButtonPress-3> {tk_popup .oztop.tab.betaUr.popup %X %Y }
     bind .oztop.tab.betaUr.draw <Double-ButtonPress-1> {tk_popup .oztop.tab.betaUr.popup %X %Y }
   
    Blt_ZoomStack $ozbetaUrGraph(w)

    ReplotOZsolver
    RefreshGraph ozSQGraph
    RefreshGraph ozgrGraph
    RefreshGraph ozcrGraph
    RefreshGraph ozbetaUrGraph
}
