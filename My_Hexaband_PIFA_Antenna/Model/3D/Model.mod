'# MWS Version: Version 2025.1 - Oct 28 2024 - ACIS 34.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.0 fmax = 0.0
'# created = '[VERSION]2025.1|34.0.1|20241028[/VERSION]


'@ use template: Antenna - Planar_3.cfg

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "GHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ define material: Copper (annealed)

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "5.8e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .DispersiveFittingSchemeMu "Nth Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .SetMaterialUnit "GHz", "mm"
     .Mu "1.0"
     .Kappa "5.8e+007"
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Component.New "component1"

'@ define brick: component1:ground

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "ground" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "L_cup" 
     .Yrange "0", "W_cup" 
     .Zrange "0", "T_gnd" 
     .Create
End With

'@ define brick: component1:substrate

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "L_cup" 
     .Yrange "0", "W_cup" 
     .Zrange "T_gnd", "((cup_layer - 1)*T_gnd + sub_layer*T_sub) + T_gnd" 
     .Create
End With

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:substrate", "11", "3"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "0.204757"
    .SetViewVector "0.958803", "-0.281984", "-0.034388"
    .SetConnectedElement1 "component1:substrate"
    .SetConnectedElement2 "component1:substrate"
    .Create
End With

Pick.ClearAllPicks

'@ define material: FR-4 (lossy)

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "GHz", "mm"
     .Epsilon "4.3"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.025"
     .TanDFreq "10.0"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .KappaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstKappa"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.3"
     .SetActiveMaterial "all"
     .Colour "0.94", "0.82", "0.76"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ change material: component1:substrate to: FR-4 (lossy)

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.ChangeMaterial "component1:substrate", "FR-4 (lossy)"

'@ define brick: component1:top patch

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "top patch" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "0", "W_patch" 
     .Yrange "0", "L_patch" 
     .Zrange "T_pcb + air_gap", "T_pcb + air_gap + T_cup" 
     .Create
End With

'@ change material: component1:top patch to: Copper (annealed)

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.ChangeMaterial "component1:top patch", "Copper (annealed)"

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:top patch", "7"

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:substrate", "4"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "1.272781"
    .SetViewVector "0.931348", "0.363081", "-0.027605"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:substrate"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:substrate", "4"

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:ground", "7"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "2"
    .SetOrientation "Smart Mode"
    .SetDistance "0.070623"
    .SetViewVector "0.931350", "0.363080", "-0.027571"
    .SetConnectedElement1 "component1:substrate"
    .SetConnectedElement2 "component1:ground"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:right patch

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "right patch" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "0", "W_patch" 
     .Yrange "0", "T_cup" 
     .Zrange "T_pcb", "T_Pcb+air_gap" 
     .Create
End With

'@ change material: component1:right patch to: Copper (annealed)

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.ChangeMaterial "component1:right patch", "Copper (annealed)"

'@ define brick: component1:Left patch a

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "Left patch a" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "W_patch-left_pa_xspan", "W_patch" 
     .Yrange "L_patch-T_cup", "L_patch" 
     .Zrange "T_Pcb+air_gap-left_pa_zspan", "T_Pcb+air_gap" 
     .Create
End With

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:Left patch a", "8", "8"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "3"
    .SetOrientation "Face"
    .SetDistance "0.661991"
    .SetOrientationFace "2"
    .SetConnectedElement1 "component1:Left patch a"
    .SetConnectedElement2 "component1:Left patch a"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:Left patch a", "11", "3"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "4"
    .SetOrientation "Smart Mode"
    .SetDistance "0.674460"
    .SetViewVector "0.749833", "-0.319389", "-0.579432"
    .SetConnectedElement1 "component1:Left patch a"
    .SetConnectedElement2 "component1:Left patch a"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:backpatch

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "backpatch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "T_cup" 
     .Yrange "L_patch-back_p_yspan", "L_Patch" 
     .Zrange "T_Pcb+air_gap-back_p_zspan", "T_Pcb+air_gap" 
     .Create
End With

'@ define brick: component1:left_patch2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "left_patch2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "T_cup", "left_patch2_xspan + T_cup" 
     .Yrange "L_patch-T_cup", "L_patch" 
     .Zrange "T_pcb+air_gap-left_patch2_zspan", "T_pcb+air_gap" 
     .Create
End With

'@ define brick: component1:left_patch2_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "left_patch2_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "T_cup + w3", "left_patch2_xspan + T_cup" 
     .Yrange "L_patch-T_cup", "L_Patch" 
     .Zrange "T_pcb + air_gap-left_patch2_zspan", "T_pcb+air_gap - w3" 
     .Create
End With

'@ boolean subtract shapes: component1:left_patch2, component1:left_patch2_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:left_patch2", "component1:left_patch2_cut"

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:left_patch2", "21"

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:left_patch2", "17"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "5"
    .SetOrientation "Force-Z"
    .SetDistance "-4.300734"
    .SetConnectedElement1 "component1:left_patch2"
    .SetConnectedElement2 "component1:left_patch2"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:left_patch2", "29", "22"

'@ define brick: component1:rectangle_patch

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "rectangle_patch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "T_cup-T_cup", "T_cup" 
     .Yrange "T_cup", "top_con_yspan" 
     .Zrange "T_pcb+air_gap-top_con_zspan", "T_pcb+air_gap" 
     .Create
End With

'@ change optimizer type

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Optimizer 
     .ActivateNonParametricOptimizer "False"
End With

'@ define brick: component1:rectangle_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "rectangle_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "T_cup-T_cup", "T_cup" 
     .Yrange "0", "top_con_yspan-cutlength" 
     .Zrange "T_pcb+air_gap-top_con_zspan", "T_pcb+air_gap-cutwidth" 
     .Create
End With

'@ boolean subtract shapes: component1:rectangle_patch, component1:rectangle_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:rectangle_patch", "component1:rectangle_cut"

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:top patch", "3", "3"

'@ define brick: component1:slot_1_rectangle_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "slot_1_rectangle_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "slot1_xspan", "slot1_xspan+w2" 
     .Yrange "0", "T_cup" 
     .Zrange "T_Pcb+air_gap-slot1_zspan", "T_Pcb+air_gap" 
     .Create
End With

'@ boolean subtract shapes: component1:right patch, component1:slot_1_rectangle_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:right patch", "component1:slot_1_rectangle_cut"

'@ define brick: component1:slot1_top_patch_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "slot1_top_patch_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "slot1_toppa_mov", "slot1_toppa_mov+w2" 
     .Yrange "0", "slot1_toppa_yspan" 
     .Zrange "T_pcb+air_gap", "T_pcb+air_gap + T_cup" 
     .Create
End With

'@ boolean subtract shapes: component1:top patch, component1:slot1_top_patch_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:top patch", "component1:slot1_top_patch_cut"

'@ define brick: component1:feed_layer1

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "feed_layer1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "feed_layer1_xspan" 
     .Yrange "top_con_yspan-feed_layer1_yspan", "top_con_yspan" 
     .Zrange "T_Pcb+air_gap-top_con_zspan - T_cup", "T_Pcb+air_gap-top_con_zspan" 
     .Create
End With

'@ define brick: component1:feed_layer1_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "feed_layer1_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "feed_layer1_xspan - layer1_slot_width", "feed_layer1_xspan" 
     .Yrange "top_con_yspan-feed_layer1_yspan/2 - layer1_slot_length/2", "top_con_yspan-feed_layer1_yspan/2 + layer1_slot_length/2" 
     .Zrange "T_pcb+air_gap-top_con_zspan - T_cup", "T_pcb+air_gap-top_con_zspan" 
     .Create
End With

'@ boolean subtract shapes: component1:feed_layer1, component1:feed_layer1_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:feed_layer1", "component1:feed_layer1_cut"

'@ define brick: component1:short_pin

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "short_pin" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "T_cup" 
     .Yrange "top_con_yspan+short_pin_gap", "top_con_yspan+short_pin_gap+w3" 
     .Zrange "0", "T_pcb+air_gap" 
     .Create
End With

'@ define brick: component1:top_patch_slot2_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "top_patch_slot2_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "W_patch-7.5", "W_patch-7.5-slot2_width" 
     .Yrange "L_patch", "L_patch-slot2_length" 
     .Zrange "T_pcb+air_gap+T_cup", "T_pcb+air_gap" 
     .Create
End With

'@ boolean subtract shapes: component1:top patch, component1:top_patch_slot2_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:top patch", "component1:top_patch_slot2_cut"

'@ define brick: component1:top_patch_slot3_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "top_patch_slot3_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "W_patch-back_p_yspan-0.8", "W_patch-back_p_yspan+width_slot3_cut - 0.8" 
     .Yrange "L_patch-slot2_length", "L_patch-slot2_length-slot3_yspan" 
     .Zrange "T_pcb+air_gap+T_cup", "T_pcb+air_gap" 
     .Create
End With

'@ boolean subtract shapes: component1:top patch, component1:top_patch_slot3_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:top patch", "component1:top_patch_slot3_cut"

'@ define brick: component1:top_patch_slot4_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "top_patch_slot4_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "W_patch-back_p_yspan - 0.8 - lcut", "W_patch-back_p_yspan - 0.8" 
     .Yrange "L_patch-length_inside_patch+w2", "L_patch-length_inside_patch" 
     .Zrange "T_pcb+air_gap+T_cup", "T_pcb+air_gap" 
     .Create
End With

'@ boolean subtract shapes: component1:top patch, component1:top_patch_slot4_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:top patch", "component1:top_patch_slot4_cut"

'@ define brick: component1:slot6_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "slot6_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "11.7-4.7", "11.7" 
     .Yrange "L_patch-5.3-.5", "L_patch-5.3" 
     .Zrange "T_pcb+air_gap+T_cup", "t_pcb+air_gap" 
     .Create
End With

'@ boolean subtract shapes: component1:top patch, component1:slot6_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:top patch", "component1:slot6_cut"

'@ define brick: component1:slot6_part2_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "slot6_part2_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "7-.5", "7" 
     .Yrange "L_patch-5.3-8.2", "L_patch-5.3" 
     .Zrange "T_pcb+air_gap+T_cup", "T_pcb+air_gap" 
     .Create
End With

'@ boolean subtract shapes: component1:top patch, component1:slot6_part2_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:top patch", "component1:slot6_part2_cut"

'@ define brick: component1:layer_3

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "layer_3" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "feed_layer1_xspan-T_cup", "feed_layer1_xspan" 
     .Yrange "top_con_yspan-feed_layer1_yspan", "top_con_yspan" 
     .Zrange "T_pcb+air_gap-top_con_zspan-1.8", "T_pcb+air_gap-top_con_zspan - T_cup" 
     .Create
End With

'@ define brick: component1:layer3_2

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "layer3_2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "feed_layer1_xspan-width_l3_2", "feed_layer1_xspan" 
     .Yrange "top_con_yspan-23.2", "top_con_yspan" 
     .Zrange "T_pcb+air_gap-top_con_zspan-1.8-T_cup", "T_pcb+air_gap-top_con_zspan-1.8" 
     .Create
End With

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:top patch", "78"

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:top patch", "50"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "6"
    .SetOrientation "Force-Y"
    .SetDistance "-10.149584"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:top patch"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:top patch", "103", "70"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "7"
    .SetOrientation "Smart Mode"
    .SetDistance "-17.393444"
    .SetViewVector "0.626031", "0.082011", "-0.775473"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:top patch"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:top patch", "108", "67"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "8"
    .SetOrientation "Smart Mode"
    .SetDistance "1.691175"
    .SetViewVector "0.501493", "0.081042", "-0.861358"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:top patch"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:top patch", "109", "78"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "9"
    .SetOrientation "Smart Mode"
    .SetDistance "-3.727951"
    .SetViewVector "0.501492", "0.081042", "-0.861358"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:top patch"
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 8

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .RemoveDimension "8"
End With

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:top patch", "119", "85"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "10"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.916807"
    .SetViewVector "0.170399", "0.054377", "-0.983874"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:top patch"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:top patch", "115", "83"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "11"
    .SetOrientation "Smart Mode"
    .SetDistance "-1.722370"
    .SetViewVector "0.170399", "0.054377", "-0.983874"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:top patch"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:top patch", "79"

'@ pick end point

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEndpointFromId "component1:top patch", "52"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "12"
    .SetOrientation "Force-Y"
    .SetDistance "-16.204002"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:top patch"
    .Create
End With

Pick.ClearAllPicks

'@ delete dimension 11

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .RemoveDimension "11"
End With

'@ delete dimension 12

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .RemoveDimension "12"
End With

'@ define brick: component1:slot2_d_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "slot2_d_cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "5", "5 + w2" 
     .Yrange "17.4 - 12.4", "17.4" 
     .Zrange "T_pcb + air_gap", "T_pcb + air_gap + T_cup" 
     .Create
End With

'@ boolean subtract shapes: component1:top patch, component1:slot2_d_cut

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Solid.Subtract "component1:top patch", "component1:slot2_d_cut"

'@ pick edge

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
Pick.PickEdgeFromId "component1:top patch", "151", "111"

'@ define distance dimension

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "13"
    .SetOrientation "Face"
    .SetDistance "-1.296622"
    .SetOrientationFace "55"
    .SetConnectedElement1 "component1:top patch"
    .SetConnectedElement2 "component1:top patch"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:Feed pin a

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "Feed pin a" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "feed_layer1_xspan-width_l3_2 - feed_pin_a_xspan", "feed_layer1_xspan-width_l3_2" 
     .Yrange "top_con_yspan-23.2 + 1.5", "top_con_yspan-23.2 + 1.5 + w2" 
     .Zrange "T_pcb+air_gap-top_con_zspan-1.8-T_cup", "T_pcb+air_gap-top_con_zspan-1.8" 
     .Create
End With

'@ define brick: component1:Feed pin b

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "Feed pin b" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "feed_layer1_xspan-width_l3_2 - feed_pin_a_xspan", "feed_layer1_xspan-width_l3_2 - feed_pin_a_xspan - w2" 
     .Yrange "top_con_yspan-23.2 + 1.5", "top_con_yspan-23.2 + 1.5 + w2 + feed_pin_b_yspan" 
     .Zrange "T_pcb+air_gap-top_con_zspan-1.8-T_cup", "T_pcb+air_gap-top_con_zspan-1.8" 
     .Create
End With

'@ define brick: component1:Feed pin c

'[VERSION]2025.1|34.0.1|20241028[/VERSION]
With Brick
     .Reset 
     .Name "Feed pin c" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "feed_layer1_xspan-width_l3_2 - feed_pin_a_xspan", "feed_layer1_xspan-width_l3_2 - feed_pin_a_xspan + T_cup" 
     .Yrange "top_con_yspan-23.2 + 1.5 + w2 + feed_pin_b_yspan - w2", "top_con_yspan-23.2 + 1.5 + w2 + feed_pin_b_yspan" 
     .Zrange "T_pcb", "T_pcb+air_gap-top_con_zspan-1.8" 
     .Create
End With

