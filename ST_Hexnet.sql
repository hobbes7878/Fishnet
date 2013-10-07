CREATE OR REPLACE FUNCTION ST_Hexnet(
        hsize integer, 
        geo_table varchar, 
        geom_column varchar)
RETURNS Table(the_geom geometry)
AS $$
DECLARE
		collected_geom geometry;
		xmin numeric;	
		xmax numeric;
		ymin numeric;	
		ymax numeric;
BEGIN
		EXECUTE 'SELECT st_transform(st_collect("'||$3||'"),32629) FROM "'||$2||'"' INTO collected_geom;
		xmax := st_xmax(collected_geom);
		xmin := st_xmin(collected_geom);
		ymin := st_ymin(collected_geom);
		ymax := st_ymax(collected_geom);


RETURN QUERY
SELECT 	
			st_translate(st_translate(cell,  (x_series*.866) , y_series ), xmin*.134 ,0)
FROM 
		generate_series(xmin::integer - $1, (xmax*1.04)::integer + $1, ($1*2)) as x_series,
		generate_series(ymin::integer- $1, ymax::integer + $1, ($1*3)) as y_series,
		(
			SELECT st_setsrid(('POLYGON((0 0,'||($1*.866)||' '||($1*.5)||','||($1*.866)||' '||$1*1.5||',0 '||($1*2)||','||($1*-.866)||' '||$1*1.5||','||($1*-.866)||' '||($1*.5)||',0 0))')::geometry ,32629) as cell
			UNION
			SELECT st_setsrid(st_translate(('POLYGON((0 0,'||($1*.866)||' '||($1*.5)||','||($1*.866)||' '||$1*1.5||',0 '||($1*2)||','||($1*-.866)||' '||$1*1.5||','||($1*-.866)||' '||($1*.5)||',0 0))')::geometry, $1*.866, $1*1.5) ,32629) as cell
		) as two_hex;


END $$ LANGUAGE plpgsql;
