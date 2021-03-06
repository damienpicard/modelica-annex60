within Annex60.Utilities.Math.Functions;
function smoothHeaviside
  "Once continuously differentiable approximation to the Heaviside function"
  input Real x "Argument";
  input Real delta "Parameter used for scaling";
  output Real y "Result";
algorithm
 y := Annex60.Utilities.Math.Functions.spliceFunction(1, 0, x, delta);
 annotation (smoothOrder = 1,
 Documentation(info="<html>
<p>
Once Lipschitz continuously differentiable approximation to the
<code>Heaviside(.,.)</code> function.
See Example <a href=\"modelica://Annex60.Utilities.Math.Examples.SmoothHeaviside\">
Annex60.Utilities.Math.Examples.SmoothHeaviside</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2015, by Marcus Fuchs:<br/>
Add link to example.
</li>
<li>
February 5, 2015, by Filip Jorissen:<br/>
Added <code>smoothOrder = 1</code>.
</li>
<li>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothHeaviside;
