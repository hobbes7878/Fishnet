ST_Hexnet()
=======

Plpgsql function for drawing a grid of regular hexagons of side length x bounding a geometry.

Usage goes:

SELECT * FROM ST_Hexnet(hex_side_length, 'geometry_table', 'the_geom')
