for i in 
#planet_alignment.gdshader
do
  for j in circle_lock.gdshader circuit.gdshader clouds.gdshader firepit.gdshader flow.gdshader glowing-edge.gdshader moving_oil.gdshader poisson_circles.gdshader pulse.gdshader sound_waves.gdshader triangle_selection.gdshader wiggle_coil.gdshader scrolling.gdshader rounded_corners.gdshader waggly_edges.gdshader ponderosa.gdshader scrolling_hash.gdshader contracting_circle.gdshader directional_pulse.gdshader planet_alignment.gdshader
  do
    c=`diff -u $i $j | grep -c '^[+-][^+-]'`
    echo $c $i $j
  done
done | sort -n
