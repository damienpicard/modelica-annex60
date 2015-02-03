within Annex60.Airflow.Multizone;
model Floor
  "Floor element for air flow benchmark, consisting of zones, hallway, outdoor environment, and staircase"

  parameter Integer nZones(min=1) = 4 "Number of zone elements";

  parameter Modelica.SIunits.Temperature TRoom = 298.15
    "Indoor air temperature of room in K";
  parameter Modelica.SIunits.Temperature THallway = 293.15
    "Indoor air temperature of hallway in K";
  parameter Modelica.SIunits.Temperature TStaircase = 293.15
    "Indoor air temperature of staircase in K";
  parameter Modelica.SIunits.Height heightRooms = 3 "Height of rooms in m";

  parameter Modelica.SIunits.Length lengthZone = 5 "Length of room in m";
  parameter Modelica.SIunits.Length widthZone = 5 "Width of room in m";
  parameter Modelica.SIunits.Length widthHallway = 3 "Width of room in m";
  parameter Real doorOpening = 1
    "Opening of door (between 0:closed and 1:open)";

  replaceable package Medium = Modelica.Media.Air.SimpleAir;
  parameter Boolean forceErrorControlOnFlow = true
    "Flag to force error control on m_flow. Set to true if interested in flow rate";

  Staircase staircase(
    heightRoom=heightRooms,
    widthRoom=widthHallway,
    redeclare package Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow,
    TRoom=TStaircase)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_top(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_top(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_bot(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_bot(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  ZoneHallway zoneHallway[nZones](
    each heightRoom=heightRooms,
    each lengthRoom=lengthZone,
    each widthRoom=widthHallway,
    redeclare each package Medium = Medium,
    each forceErrorControlOnFlow=forceErrorControlOnFlow,
    each TRoom=THallway)       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-30})));
  OutsideEnvironment outsideEnvironment[nZones](redeclare each package Medium
      =                                                                         Medium,
      each heightRoom=heightRooms)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  SimpleZone simpleZone[nZones](
    each heightRoom=heightRooms,
    each lengthRoom=lengthZone,
    each widthRoom=widthZone,
    redeclare each package Medium = Medium,
    each forceErrorControlOnFlow=forceErrorControlOnFlow,
    each TRoom=TRoom)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_vent[nZones](redeclare each
      package Medium =
        Medium) "Port to connect mechanical ventilation equipment to each zone"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  BoundaryConditions.WeatherData.Bus weaBus1 "Bus with weather data"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
equation
  connect(staircase.port_a_top, port_a_top) annotation (Line(
      points={{64,10},{40,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_b_top, port_b_top) annotation (Line(
      points={{76,10},{80,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_a_bot, port_a_bot) annotation (Line(
      points={{64,-10},{40,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_b_bot, port_b_bot) annotation (Line(
      points={{76,-10},{80,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_a_toHallway, zoneHallway[1].port_a2) annotation (Line(
      points={{60,6},{-36,6},{-36,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_b_toHallway, zoneHallway[1].port_b2) annotation (Line(
      points={{60,-6},{-24,-6},{-24,-20}},
      color={0,127,255},
      smooth=Smooth.None));

  for i in 1:(nZones-1) loop
    connect(zoneHallway[i].port_a1, zoneHallway[i+1].port_a2);
    connect(zoneHallway[i].port_b1, zoneHallway[i+1].port_b2);
  end for;

  for i in 1:nZones loop
    connect(simpleZone[i].port_a, zoneHallway[i].port_a_toZone) annotation (Line(
      points={{-60,-24},{-40,-24}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(simpleZone[i].port_b, zoneHallway[i].port_b_toZone) annotation (Line(
      points={{-60,-36},{-40,-36}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(zoneHallway[i].port_a_toOutside, outsideEnvironment[i].port_a)
    annotation (Line(
      points={{-20,-24},{0,-24}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(zoneHallway[i].port_b_toOutside, outsideEnvironment[i].port_b)
    annotation (Line(
      points={{-20,-36},{0,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  for i in 1:nZones loop
    connect(port_a_vent[i], simpleZone[i].port_a_vent) annotation (Line(
      points={{-100,60},{-88,60},{-88,-22},{-80,-22}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;

  for i in 1:nZones loop
    connect(outsideEnvironment[i].weaBus1, weaBus1) annotation (Line(
      points={{20,-30},{34,-30},{34,-72},{-40,-72},{-40,-100}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Floor;
